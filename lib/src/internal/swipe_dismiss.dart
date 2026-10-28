/// Gesture detection for swipe-to-dismiss on toast cards.
library;

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_sonner_smooth/src/toast_animations.dart';
import 'package:flutter_sonner_smooth/src/toast_types.dart';

/// Wraps a child widget with swipe-to-dismiss gesture handling.
///
/// Tracks pan velocity and either dismisses with momentum or springs back.
class SwipeDismiss extends StatefulWidget {
  /// Creates a swipe-dismiss wrapper.
  const SwipeDismiss({
    required this.child,
    required this.onDismissed,
    required this.position,
    this.direction = SwipeDirection.auto,
    super.key,
  });

  /// The toast widget to make dismissible.
  final Widget child;

  /// Called when the swipe completes a dismiss.
  final VoidCallback onDismissed;

  /// The toast's screen position, used to determine swipe direction.
  final ToastPosition position;

  /// Override for swipe direction.
  final SwipeDirection direction;

  @override
  State<SwipeDismiss> createState() => _SwipeDismissState();
}

class _SwipeDismissState extends State<SwipeDismiss>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isDismissing = false;

  bool get _isHorizontal {
    switch (widget.direction) {
      case SwipeDirection.horizontal:
        return true;
      case SwipeDirection.vertical:
        return false;
      case SwipeDirection.none:
        return true;
      case SwipeDirection.auto:
        return true;
    }
  }

  bool get _isDisabled => widget.direction == SwipeDirection.none;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isDisabled || _isDismissing) return;
    final delta = _isHorizontal ? details.delta.dx : details.delta.dy;
    _controller.value += delta;
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isDisabled || _isDismissing) return;
    final velocity = _isHorizontal
        ? details.velocity.pixelsPerSecond.dx
        : details.velocity.pixelsPerSecond.dy;

    if (velocity.abs() > 500 || _controller.value.abs() > 80) {
      _isDismissing = true;
      final target = _controller.value > 0 ? 400.0 : -400.0;
      final simulation = SpringSimulation(
        ToastSpring.exit,
        _controller.value,
        target,
        velocity,
      );
      _controller.animateWith(simulation).then((_) {
        if (mounted) widget.onDismissed();
      });
    } else {
      final simulation = SpringSimulation(
        ToastSpring.enter,
        _controller.value,
        0,
        velocity,
      );
      _controller.animateWith(simulation);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dragOffset = _controller.value;
        final opacity = 1.0 - (dragOffset.abs() / 200).clamp(0.0, 1.0);
        final offset = _isHorizontal
            ? Offset(dragOffset, 0)
            : Offset(0, dragOffset);

        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: widget.child,
      ),
    );
  }
}
