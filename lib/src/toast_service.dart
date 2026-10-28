/// Internal state manager for toast notifications.
///
/// Not exposed publicly — users interact via the [toast] singleton.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import 'toast_entry.dart';
import 'toast_types.dart';

int _idCounter = 0;

/// Generates a unique toast ID from timestamp + counter.
String generateToastId() =>
    '${DateTime.now().microsecondsSinceEpoch}_${_idCounter++}';

/// Internal singleton that manages the list of active toasts and their
/// auto-dismiss timers.
class ToastService extends ChangeNotifier {
  ToastService._();

  /// The shared instance.
  static final ToastService instance = ToastService._();

  final List<ToastEntry> _entries = [];
  final Map<String, Timer> _timers = {};

  /// An unmodifiable view of the current toast entries, newest first.
  List<ToastEntry> get entries => List<ToastEntry>.unmodifiable(_entries);

  /// Adds a toast and schedules auto-dismiss if applicable.
  String add(ToastEntry entry) {
    _entries.insert(0, entry);
    if (entry.type != ToastType.loading) {
      _scheduleAutoDismiss(entry);
    }
    notifyListeners();
    return entry.id;
  }

  /// Removes a toast by [id] and cancels its timer.
  void remove(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final entry = _entries.removeAt(index);
      entry.onDismissed?.call();
      notifyListeners();
    }
  }

  /// Removes all toasts.
  void removeAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    for (final entry in _entries) {
      entry.onDismissed?.call();
    }
    _entries.clear();
    notifyListeners();
  }

  /// Updates a toast in place using the [updater] function.
  void update(String id, ToastEntry Function(ToastEntry) updater) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _entries[index] = updater(_entries[index]);
      notifyListeners();
    }
  }

  /// Finds a toast by its [id], or returns `null`.
  ToastEntry? findById(String id) {
    for (final entry in _entries) {
      if (entry.id == id) return entry;
    }
    return null;
  }

  /// Schedules auto-dismiss for the given [entry].
  void scheduleAutoDismiss(ToastEntry entry) => _scheduleAutoDismiss(entry);

  void _scheduleAutoDismiss(ToastEntry entry) {
    _timers[entry.id]?.cancel();
    _timers[entry.id] = Timer(entry.duration, () {
      remove(entry.id);
    });
  }

  /// Pauses the auto-dismiss timer for [id].
  void pauseTimer(String id) {
    _timers[id]?.cancel();
    _timers.remove(id);
  }

  /// Resumes the auto-dismiss timer for [id] with [remaining] duration.
  void resumeTimer(String id, Duration remaining) {
    final entry = findById(id);
    if (entry != null && entry.type != ToastType.loading) {
      _timers[id]?.cancel();
      _timers[id] = Timer(remaining, () {
        remove(id);
      });
    }
  }

  /// Resets the service state. For testing only.
  @visibleForTesting
  void reset() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _entries.clear();
    _idCounter = 0;
    notifyListeners();
  }
}
