/// Pure math for computing toast stack positions and scales.
library;

import 'dart:ui';

import 'package:flutter_sonner_smooth/src/toast_types.dart';

/// The computed transform for a single toast in the stack.
class ToastTransform {
  /// Creates a toast transform.
  const ToastTransform({
    required this.offset,
    required this.scale,
    required this.opacity,
  });

  /// Positional offset from the stack anchor.
  final Offset offset;

  /// Scale factor (1.0 = full size).
  final double scale;

  /// Opacity (0.0 = invisible, 1.0 = fully visible).
  final double opacity;
}

/// Computes toast positions within a collapsed or expanded stack.
class StackLayout {
  StackLayout._();

  /// Returns the [ToastTransform] for a toast at [index] from the newest.
  ///
  /// [index] 0 = newest (front), 1 = second-newest, etc.
  static ToastTransform compute({
    required int index,
    required int totalVisible,
    required bool expanded,
    required double toastHeight,
    required double gap,
    required double expandedGap,
    required ToastPosition position,
  }) {
    if (expanded) {
      final dy = (toastHeight + expandedGap) * index;
      return ToastTransform(
        offset: Offset(0, _directionMultiplier(position) * dy),
        scale: 1.0,
        opacity: 1.0,
      );
    }

    final dy = gap * index;
    final scale = 1.0 - (0.05 * index.clamp(0, 2));
    final opacity = index < 3 ? 1.0 - (0.15 * index) : 0.0;
    return ToastTransform(
      offset: Offset(0, _directionMultiplier(position) * dy),
      scale: scale,
      opacity: opacity,
    );
  }

  static double _directionMultiplier(ToastPosition pos) {
    return pos.name.startsWith('top') ? 1.0 : -1.0;
  }
}
