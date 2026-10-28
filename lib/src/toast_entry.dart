/// Immutable data model representing a single toast notification.
library;

import 'package:flutter/foundation.dart';

import 'toast_types.dart';

/// An immutable snapshot of a toast notification's data.
///
/// Each toast is identified by a unique [id] and carries its display
/// content, type, duration, and position. Use [copyWith] to derive
/// a modified copy.
@immutable
class ToastEntry {
  /// Creates a toast entry.
  const ToastEntry({
    required this.id,
    required this.message,
    required this.type,
    required this.duration,
    required this.position,
    required this.createdAt,
    this.description,
    this.onDismissed,
  });

  /// Unique identifier for this toast.
  final String id;

  /// The primary message displayed in the toast.
  final String message;

  /// Optional secondary description text.
  final String? description;

  /// The visual type (success, error, etc.).
  final ToastType type;

  /// How long the toast stays visible before auto-dismissing.
  final Duration duration;

  /// Where on the screen this toast is displayed.
  final ToastPosition position;

  /// When this toast was created.
  final DateTime createdAt;

  /// Called when the toast is dismissed by the user.
  final VoidCallback? onDismissed;

  /// Returns a copy with the given fields replaced.
  ToastEntry copyWith({
    String? id,
    String? message,
    String? description,
    ToastType? type,
    Duration? duration,
    ToastPosition? position,
    DateTime? createdAt,
    VoidCallback? onDismissed,
  }) {
    return ToastEntry(
      id: id ?? this.id,
      message: message ?? this.message,
      description: description ?? this.description,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      onDismissed: onDismissed ?? this.onDismissed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ToastEntry &&
        other.id == id &&
        other.message == message &&
        other.description == description &&
        other.type == type &&
        other.duration == duration &&
        other.position == position &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        message,
        description,
        type,
        duration,
        position,
        createdAt,
      );

  @override
  String toString() =>
      'ToastEntry(id: $id, type: $type, message: $message)';
}
