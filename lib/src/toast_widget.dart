/// The visual representation of a single toast card.
library;

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'toast_entry.dart';
import 'toast_theme.dart';
import 'toast_types.dart';

/// Renders a single toast card with icon, message, description, and progress.
class ToastWidget extends StatelessWidget {
  /// Creates a toast widget.
  const ToastWidget({
    required this.entry,
    required this.progress,
    super.key,
  });

  /// The data model for this toast.
  final ToastEntry entry;

  /// Progress from 1.0 (just shown) to 0.0 (about to dismiss).
  /// Null means no progress bar (loading toasts).
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final theme = ToastTheme.of(context);
    final accentColor = _accentColor(theme);

    return Container(
      constraints: BoxConstraints(
        maxWidth: theme.maxWidth,
        minWidth: theme.minWidth,
      ),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
          color: theme.borderColor,
          width: 0.5,
        ),
        boxShadow: theme.shadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: theme.padding,
            child: Row(
              children: [
                if (entry.type != ToastType.neutral) ...[
                  _buildIcon(accentColor),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.message,
                        style: theme.messageStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (entry.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          entry.description!,
                          style: theme.descriptionStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (progress != null)
            _ProgressBar(
              progress: progress!,
              color: accentColor ?? theme.textColor,
            ),
        ],
      ),
    );
  }

  Color? _accentColor(ToastThemeData theme) {
    switch (entry.type) {
      case ToastType.success:
        return theme.successColor;
      case ToastType.error:
        return theme.errorColor;
      case ToastType.warning:
        return theme.warningColor;
      case ToastType.info:
        return theme.infoColor;
      case ToastType.loading:
        return theme.descriptionColor;
      case ToastType.neutral:
        return null;
    }
  }

  Widget _buildIcon(Color? color) {
    if (entry.type == ToastType.loading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: _LoadingSpinner(color: color ?? const Color(0xFF71717A)),
      );
    }

    return _ToastIcon(type: entry.type, color: color!);
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: ColoredBox(color: color.withValues(alpha: 0.4)),
      ),
    );
  }
}

class _LoadingSpinner extends StatefulWidget {
  const _LoadingSpinner({required this.color});

  final Color color;

  @override
  State<_LoadingSpinner> createState() => _LoadingSpinnerState();
}

class _LoadingSpinnerState extends State<_LoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _SpinnerPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 2) / 2;

    canvas.drawCircle(center, radius, paint);

    paint.color = color;
    const sweepAngle = 1.5;
    final startAngle = progress * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

class _ToastIcon extends StatelessWidget {
  const _ToastIcon({required this.type, required this.color});

  final ToastType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _IconPainter(type: type, color: color)),
    );
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter({required this.type, required this.color});

  final ToastType type;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 1;

    switch (type) {
      case ToastType.success:
        canvas.drawCircle(Offset(cx, cy), r, paint);
        final path = Path()
          ..moveTo(cx - 4, cy)
          ..lineTo(cx - 1, cy + 3)
          ..lineTo(cx + 5, cy - 3);
        canvas.drawPath(path, paint);
      case ToastType.error:
        canvas.drawCircle(Offset(cx, cy), r, paint);
        canvas.drawLine(
          Offset(cx - 3, cy - 3),
          Offset(cx + 3, cy + 3),
          paint,
        );
        canvas.drawLine(
          Offset(cx + 3, cy - 3),
          Offset(cx - 3, cy + 3),
          paint,
        );
      case ToastType.warning:
        final path = Path()
          ..moveTo(cx, cy - r)
          ..lineTo(cx + r, cy + r * 0.7)
          ..lineTo(cx - r, cy + r * 0.7)
          ..close();
        canvas.drawPath(path, paint);
        canvas.drawLine(Offset(cx, cy - 2), Offset(cx, cy + 1), paint);
        canvas.drawCircle(
          Offset(cx, cy + 4),
          0.8,
          paint..style = PaintingStyle.fill,
        );
        paint.style = PaintingStyle.stroke;
      case ToastType.info:
        canvas.drawCircle(Offset(cx, cy), r, paint);
        canvas.drawLine(Offset(cx, cy - 1), Offset(cx, cy + 4), paint);
        canvas.drawCircle(
          Offset(cx, cy - 4),
          0.8,
          paint..style = PaintingStyle.fill,
        );
        paint.style = PaintingStyle.stroke;
      case ToastType.neutral:
      case ToastType.loading:
        break;
    }
  }

  @override
  bool shouldRepaint(_IconPainter oldDelegate) =>
      type != oldDelegate.type || color != oldDelegate.color;
}
