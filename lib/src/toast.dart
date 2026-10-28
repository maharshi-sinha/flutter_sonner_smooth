/// The public-facing toast API singleton.
///
/// ```dart
/// toast('Hello');
/// toast.success('Saved');
/// toast.promise(future, loading: '...', success: (_) => '...', error: (_) => '...');
/// ```
library;

import 'package:flutter/widgets.dart';

import 'toast_entry.dart';
import 'toast_service.dart';
import 'toast_types.dart';

/// The global toast singleton. Call it directly or use its named methods.
///
/// ```dart
/// toast('Hello world');
/// toast.success('Saved successfully');
/// ```
final Toast toast = Toast._();

const Duration _defaultDuration = Duration(seconds: 4);
const Duration _errorDuration = Duration(seconds: 6);

/// The public API for showing, dismissing, and updating toasts.
///
/// Access via the top-level [toast] singleton. Do not instantiate directly.
class Toast {
  Toast._();

  ToastPosition _defaultPosition = ToastPosition.topRight;

  /// Sets the default position for toasts when not overridden per-call.
  set defaultPosition(ToastPosition position) => _defaultPosition = position;

  /// Shows a neutral toast with no icon.
  String call(
    String message, {
    String? description,
    Duration? duration,
    ToastPosition? position,
    VoidCallback? onDismissed,
  }) {
    return _show(
      message: message,
      description: description,
      type: ToastType.neutral,
      duration: duration ?? _defaultDuration,
      position: position,
      onDismissed: onDismissed,
    );
  }

  /// Shows a success toast with a green check icon.
  String success(
    String message, {
    String? description,
    Duration? duration,
    ToastPosition? position,
    VoidCallback? onDismissed,
  }) {
    return _show(
      message: message,
      description: description,
      type: ToastType.success,
      duration: duration ?? _defaultDuration,
      position: position,
      onDismissed: onDismissed,
    );
  }

  /// Shows an error toast with a red alert icon.
  ///
  /// Defaults to a 6-second duration for better readability.
  String error(
    String message, {
    String? description,
    Duration? duration,
    ToastPosition? position,
    VoidCallback? onDismissed,
  }) {
    return _show(
      message: message,
      description: description,
      type: ToastType.error,
      duration: duration ?? _errorDuration,
      position: position,
      onDismissed: onDismissed,
    );
  }

  /// Shows a warning toast with an amber warning icon.
  String warning(
    String message, {
    String? description,
    Duration? duration,
    ToastPosition? position,
    VoidCallback? onDismissed,
  }) {
    return _show(
      message: message,
      description: description,
      type: ToastType.warning,
      duration: duration ?? _defaultDuration,
      position: position,
      onDismissed: onDismissed,
    );
  }

  /// Shows an info toast with a blue info icon.
  String info(
    String message, {
    String? description,
    Duration? duration,
    ToastPosition? position,
    VoidCallback? onDismissed,
  }) {
    return _show(
      message: message,
      description: description,
      type: ToastType.info,
      duration: duration ?? _defaultDuration,
      position: position,
      onDismissed: onDismissed,
    );
  }

  /// Shows a loading toast with a spinner. Does **not** auto-dismiss.
  String loading(
    String message, {
    String? description,
    ToastPosition? position,
  }) {
    return _show(
      message: message,
      description: description,
      type: ToastType.loading,
      duration: Duration.zero,
      position: position,
    );
  }

  /// Shows a promise toast that auto-transitions loading -> success/error.
  String promise<T>(
    Future<T> future, {
    required String loading,
    required String Function(T value) success,
    required String Function(Object error) error,
    String? description,
    ToastPosition? position,
  }) {
    final id = this.loading(
      loading,
      description: description,
      position: position,
    );

    future.then(
      (value) {
        final service = ToastService.instance;
        if (service.findById(id) == null) return;
        service.update(
          id,
          (e) => e.copyWith(
            type: ToastType.success,
            message: success(value),
            duration: _defaultDuration,
          ),
        );
        final updated = service.findById(id);
        if (updated != null) service.scheduleAutoDismiss(updated);
      },
      onError: (Object err) {
        final service = ToastService.instance;
        if (service.findById(id) == null) return;
        service.update(
          id,
          (e) => e.copyWith(
            type: ToastType.error,
            message: error(err),
            duration: _errorDuration,
          ),
        );
        final updated = service.findById(id);
        if (updated != null) service.scheduleAutoDismiss(updated);
      },
    );

    return id;
  }

  /// Dismisses a specific toast by [id] with an exit animation.
  void dismiss(String id) {
    ToastService.instance.remove(id);
  }

  /// Dismisses all currently visible toasts.
  void dismissAll() {
    ToastService.instance.removeAll();
  }

  /// Updates an existing toast's content.
  void update(
    String id, {
    String? message,
    String? description,
    ToastType? type,
    Duration? duration,
  }) {
    ToastService.instance.update(id, (entry) {
      return entry.copyWith(
        message: message,
        description: description,
        type: type,
        duration: duration,
      );
    });
  }

  String _show({
    required String message,
    required ToastType type,
    required Duration duration,
    String? description,
    ToastPosition? position,
    VoidCallback? onDismissed,
  }) {
    final entry = ToastEntry(
      id: generateToastId(),
      message: message,
      description: description,
      type: type,
      duration: duration,
      position: position ?? _defaultPosition,
      createdAt: DateTime.now(),
      onDismissed: onDismissed,
    );
    return ToastService.instance.add(entry);
  }
}
