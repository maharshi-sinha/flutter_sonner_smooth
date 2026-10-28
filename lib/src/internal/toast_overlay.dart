/// Overlay rendering for toast stacks — animates entry/exit/reorder.
library;

import 'dart:async';

import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_sonner_smooth/src/internal/stack_layout.dart';
import 'package:flutter_sonner_smooth/src/internal/swipe_dismiss.dart';
import 'package:flutter_sonner_smooth/src/toast_animations.dart';
import 'package:flutter_sonner_smooth/src/toast_entry.dart';
import 'package:flutter_sonner_smooth/src/toast_service.dart';
import 'package:flutter_sonner_smooth/src/toast_theme.dart';
import 'package:flutter_sonner_smooth/src/toast_types.dart';
import 'package:flutter_sonner_smooth/src/toast_widget.dart';

/// Renders a positioned stack of toasts for a given [ToastPosition].
class ToastStack extends StatefulWidget {
  /// Creates a toast stack.
  const ToastStack({
    required this.position,
    required this.maxVisible,
    required this.gap,
    required this.expandedGap,
    required this.margin,
    required this.swipeDirection,
    required this.expandOnHover,
    super.key,
  });

  /// The corner/edge this stack is anchored to.
  final ToastPosition position;

  /// Maximum number of toasts visible at once.
  final int maxVisible;

  /// Gap between collapsed toasts.
  final double gap;

  /// Gap between expanded toasts.
  final double expandedGap;

  /// Outer margin from the screen edge.
  final EdgeInsets margin;

  /// Swipe direction for dismissing.
  final SwipeDirection swipeDirection;

  /// Whether to expand the stack on hover (desktop/web).
  final bool expandOnHover;

  @override
  State<ToastStack> createState() => _ToastStackState();
}

class _ToastStackState extends State<ToastStack> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ToastService.instance,
      builder: (context, _) {
        final allEntries = ToastService.instance.entries
            .where((e) => e.position == widget.position)
            .toList();

        if (allEntries.isEmpty) return const SizedBox.shrink();

        final visible = allEntries.take(widget.maxVisible).toList();

        return Positioned(
          top: _isTop ? widget.margin.top : null,
          bottom: _isTop ? null : widget.margin.bottom,
          left: _horizontalLeft,
          right: _horizontalRight,
          child: MouseRegion(
            onEnter: widget.expandOnHover
                ? (_) => setState(() => _expanded = true)
                : null,
            onExit: widget.expandOnHover
                ? (_) => setState(() => _expanded = false)
                : null,
            child: GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              behavior: HitTestBehavior.deferToChild,
              child: SizedBox(
                width: ToastTheme.of(context).maxWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: _stackAlignment,
                  children: [
                    for (var i = visible.length - 1; i >= 0; i--)
                      _AnimatedToastItem(
                        key: ValueKey<String>(visible[i].id),
                        entry: visible[i],
                        index: i,
                        totalVisible: visible.length,
                        expanded: _expanded,
                        gap: widget.gap,
                        expandedGap: widget.expandedGap,
                        position: widget.position,
                        swipeDirection: widget.swipeDirection,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool get _isTop => widget.position.name.startsWith('top');

  double? get _horizontalLeft {
    switch (widget.position) {
      case ToastPosition.topLeft:
      case ToastPosition.bottomLeft:
        return widget.margin.left;
      case ToastPosition.topCenter:
      case ToastPosition.bottomCenter:
        return 0;
      case ToastPosition.topRight:
      case ToastPosition.bottomRight:
        return null;
    }
  }

  double? get _horizontalRight {
    switch (widget.position) {
      case ToastPosition.topRight:
      case ToastPosition.bottomRight:
        return widget.margin.right;
      case ToastPosition.topCenter:
      case ToastPosition.bottomCenter:
        return 0;
      case ToastPosition.topLeft:
      case ToastPosition.bottomLeft:
        return null;
    }
  }

  Alignment get _stackAlignment {
    switch (widget.position) {
      case ToastPosition.topLeft:
      case ToastPosition.bottomLeft:
        return _isTop ? Alignment.topLeft : Alignment.bottomLeft;
      case ToastPosition.topCenter:
      case ToastPosition.bottomCenter:
        return _isTop ? Alignment.topCenter : Alignment.bottomCenter;
      case ToastPosition.topRight:
      case ToastPosition.bottomRight:
        return _isTop ? Alignment.topRight : Alignment.bottomRight;
    }
  }
}

class _AnimatedToastItem extends StatefulWidget {
  const _AnimatedToastItem({
    required this.entry,
    required this.index,
    required this.totalVisible,
    required this.expanded,
    required this.gap,
    required this.expandedGap,
    required this.position,
    required this.swipeDirection,
    super.key,
  });

  final ToastEntry entry;
  final int index;
  final int totalVisible;
  final bool expanded;
  final double gap;
  final double expandedGap;
  final ToastPosition position;
  final SwipeDirection swipeDirection;

  @override
  State<_AnimatedToastItem> createState() => _AnimatedToastItemState();
}

class _AnimatedToastItemState extends State<_AnimatedToastItem>
    with TickerProviderStateMixin {
  late final AnimationController _enterController;
  late final AnimationController _offsetController;
  late final AnimationController _scaleController;

  double _progress = 1.0;
  Timer? _progressTimer;
  bool _hovered = false;
  DateTime? _pausedAt;
  Duration _remainingDuration = Duration.zero;

  static const _toastHeight = 60.0;

  @override
  void initState() {
    super.initState();

    _enterController = AnimationController(vsync: this, value: 0);
    _offsetController = AnimationController.unbounded(vsync: this);
    _scaleController = AnimationController.unbounded(vsync: this, value: 1);

    _animateEnter();
    _updateStackPosition();
    _startProgressTimer();
  }

  void _animateEnter() {
    final simulation = SpringSimulation(ToastSpring.enter, 0.0, 1.0, 0.0);
    _enterController.animateWith(simulation);
  }

  void _startProgressTimer() {
    if (widget.entry.type == ToastType.loading ||
        widget.entry.duration == Duration.zero) {
      _progress = -1;
      return;
    }

    _remainingDuration = widget.entry.duration;
    final totalMs = widget.entry.duration.inMilliseconds;
    if (totalMs <= 0) return;

    const tickInterval = Duration(milliseconds: 16);
    _progressTimer = Timer.periodic(tickInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_hovered) return;
      setState(() {
        _progress -= 16 / totalMs;
        if (_progress < 0) _progress = 0;
      });
    });
  }

  @override
  void didUpdateWidget(_AnimatedToastItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index ||
        oldWidget.expanded != widget.expanded) {
      _updateStackPosition();
    }

    if (oldWidget.entry.type != widget.entry.type) {
      _progressTimer?.cancel();
      _progress = 1.0;
      _startProgressTimer();
    }
  }

  void _updateStackPosition() {
    final transform = StackLayout.compute(
      index: widget.index,
      totalVisible: widget.totalVisible,
      expanded: widget.expanded,
      toastHeight: _toastHeight,
      gap: widget.gap,
      expandedGap: widget.expandedGap,
      position: widget.position,
    );

    _offsetController.animateWith(
      SpringSimulation(
        ToastSpring.stackShift,
        _offsetController.value,
        transform.offset.dy,
        0,
      ),
    );

    _scaleController.animateWith(
      SpringSimulation(
        ToastSpring.stackShift,
        _scaleController.value,
        transform.scale,
        0,
      ),
    );
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _enterController.dispose();
    _offsetController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    _hovered = true;
    _pausedAt = DateTime.now();
    ToastService.instance.pauseTimer(widget.entry.id);
  }

  void _onHoverExit() {
    _hovered = false;
    if (_pausedAt != null && widget.entry.type != ToastType.loading) {
      final elapsed = DateTime.now().difference(_pausedAt!);
      final remaining = _remainingDuration - elapsed;
      if (remaining > Duration.zero) {
        _remainingDuration = remaining;
        ToastService.instance.resumeTimer(widget.entry.id, remaining);
      }
    }
    _pausedAt = null;
  }

  @override
  Widget build(BuildContext context) {
    final transform = StackLayout.compute(
      index: widget.index,
      totalVisible: widget.totalVisible,
      expanded: widget.expanded,
      toastHeight: _toastHeight,
      gap: widget.gap,
      expandedGap: widget.expandedGap,
      position: widget.position,
    );

    return AnimatedBuilder(
      animation: Listenable.merge([
        _enterController,
        _offsetController,
        _scaleController,
      ]),
      builder: (context, child) {
        final enterValue = _enterController.value.clamp(0.0, 1.0);
        final isTop = widget.position.name.startsWith('top');
        final slideOffset = (1 - enterValue) * (isTop ? -40.0 : 40.0);

        return Transform.translate(
          offset: Offset(0, _offsetController.value + slideOffset),
          child: Transform.scale(
            scale: _scaleController.value * (0.9 + 0.1 * enterValue),
            alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: Opacity(
              opacity: (enterValue * transform.opacity).clamp(0.0, 1.0),
              child: child,
            ),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _onHoverEnter(),
        onExit: (_) => _onHoverExit(),
        child: SwipeDismiss(
          position: widget.position,
          direction: widget.swipeDirection,
          onDismissed: () {
            ToastService.instance.remove(widget.entry.id);
          },
          child: GestureDetector(
            onTap: () {
              ToastService.instance.remove(widget.entry.id);
            },
            child: ToastWidget(
              entry: widget.entry,
              progress: _progress >= 0 ? _progress : null,
            ),
          ),
        ),
      ),
    );
  }
}
