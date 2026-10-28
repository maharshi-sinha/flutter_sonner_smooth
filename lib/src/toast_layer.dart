/// The user-facing overlay widget that renders toast stacks.
///
/// Mount once in [MaterialApp.builder]:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ToastLayer(child: child!),
///   home: const HomePage(),
/// );
/// ```
library;

import 'package:flutter/widgets.dart';

import 'internal/toast_overlay.dart';
import 'toast.dart';
import 'toast_theme.dart';
import 'toast_types.dart';

/// Overlay widget that renders toast notification stacks.
///
/// Wrap your app with this widget to enable context-free toasts:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ToastLayer(child: child!),
///   home: const HomePage(),
/// );
/// ```
class ToastLayer extends StatefulWidget {
  /// Creates a toast layer.
  const ToastLayer({
    required this.child,
    this.position = ToastPosition.topRight,
    this.maxVisible = 3,
    this.gap = 8.0,
    this.expandedGap = 12.0,
    this.theme,
    this.margin = const EdgeInsets.all(16),
    this.swipeDirection = SwipeDirection.auto,
    this.expandOnHover = true,
    super.key,
  });

  /// The app content below the toast overlay.
  final Widget child;

  /// Default position for toasts.
  final ToastPosition position;

  /// Maximum number of toasts visible at once per position.
  final int maxVisible;

  /// Gap between collapsed toasts (in pixels).
  final double gap;

  /// Gap between expanded toasts (in pixels).
  final double expandedGap;

  /// Custom theme data. Auto-selects light/dark if null.
  final ToastThemeData? theme;

  /// Outer margin from screen edges.
  final EdgeInsets margin;

  /// Swipe direction for dismissing toasts.
  final SwipeDirection swipeDirection;

  /// Whether to expand the stack on hover (desktop/web).
  final bool expandOnHover;

  @override
  State<ToastLayer> createState() => _ToastLayerState();
}

class _ToastLayerState extends State<ToastLayer> {
  @override
  void initState() {
    super.initState();
    toast.defaultPosition = widget.position;
  }

  @override
  void didUpdateWidget(ToastLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.position != widget.position) {
      toast.defaultPosition = widget.position;
    }
  }

  ToastThemeData _resolveTheme(BuildContext context) {
    if (widget.theme != null) return widget.theme!;
    final brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark
        ? ToastThemeData.dark()
        : ToastThemeData.light();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTheme = _resolveTheme(context);

    return ToastTheme(
      data: resolvedTheme,
      child: Stack(
        children: [
          widget.child,
          for (final pos in ToastPosition.values)
            ToastStack(
              position: pos,
              maxVisible: widget.maxVisible,
              gap: widget.gap,
              expandedGap: widget.expandedGap,
              margin: widget.margin,
              swipeDirection: widget.swipeDirection,
              expandOnHover: widget.expandOnHover,
            ),
        ],
      ),
    );
  }
}
