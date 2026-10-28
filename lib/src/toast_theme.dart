/// Theming for toast notifications.
library;

import 'package:flutter/widgets.dart';

/// Theme data controlling the visual appearance of toasts.
@immutable
class ToastThemeData {
  /// Creates a toast theme with all visual properties.
  const ToastThemeData({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.descriptionColor,
    required this.successColor,
    required this.errorColor,
    required this.warningColor,
    required this.infoColor,
    required this.borderRadius,
    required this.padding,
    required this.maxWidth,
    required this.minWidth,
    required this.messageStyle,
    required this.descriptionStyle,
    required this.shadow,
  });

  /// Creates the default light theme following iOS 17 / macOS Sonoma style.
  factory ToastThemeData.light() {
    return const ToastThemeData(
      backgroundColor: Color(0xFFFFFFFF),
      borderColor: Color(0x14000000),
      textColor: Color(0xFF18181B),
      descriptionColor: Color(0xFF71717A),
      successColor: Color(0xFF10B981),
      errorColor: Color(0xFFEF4444),
      warningColor: Color(0xFFF59E0B),
      infoColor: Color(0xFF3B82F6),
      borderRadius: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      maxWidth: 356.0,
      minWidth: 280.0,
      messageStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF18181B),
        decoration: TextDecoration.none,
      ),
      descriptionStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFF71717A),
        decoration: TextDecoration.none,
      ),
      shadow: [
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  /// Creates the default dark theme.
  factory ToastThemeData.dark() {
    return const ToastThemeData(
      backgroundColor: Color(0xFF18181B),
      borderColor: Color(0x1AFFFFFF),
      textColor: Color(0xFFFAFAFA),
      descriptionColor: Color(0xFFA1A1AA),
      successColor: Color(0xFF34D399),
      errorColor: Color(0xFFF87171),
      warningColor: Color(0xFFFBBF24),
      infoColor: Color(0xFF60A5FA),
      borderRadius: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      maxWidth: 356.0,
      minWidth: 280.0,
      messageStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFFAFAFA),
        decoration: TextDecoration.none,
      ),
      descriptionStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Color(0xFFA1A1AA),
        decoration: TextDecoration.none,
      ),
      shadow: [
        BoxShadow(
          color: Color(0x29000000),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  /// The toast background color.
  final Color backgroundColor;

  /// The hairline border color.
  final Color borderColor;

  /// The primary message text color.
  final Color textColor;

  /// The secondary description text color.
  final Color descriptionColor;

  /// Accent color for success toasts.
  final Color successColor;

  /// Accent color for error toasts.
  final Color errorColor;

  /// Accent color for warning toasts.
  final Color warningColor;

  /// Accent color for info toasts.
  final Color infoColor;

  /// Corner radius of the toast card.
  final double borderRadius;

  /// Inner padding of the toast card.
  final EdgeInsets padding;

  /// Maximum width of the toast card.
  final double maxWidth;

  /// Minimum width of the toast card.
  final double minWidth;

  /// Text style for the primary message.
  final TextStyle messageStyle;

  /// Text style for the description.
  final TextStyle descriptionStyle;

  /// Box shadow list for the toast card.
  final List<BoxShadow> shadow;

  /// Returns a copy with the given fields replaced.
  ToastThemeData copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    Color? descriptionColor,
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
    double? borderRadius,
    EdgeInsets? padding,
    double? maxWidth,
    double? minWidth,
    TextStyle? messageStyle,
    TextStyle? descriptionStyle,
    List<BoxShadow>? shadow,
  }) {
    return ToastThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      messageStyle: messageStyle ?? this.messageStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      shadow: shadow ?? this.shadow,
    );
  }

  /// Linearly interpolates between two [ToastThemeData]s.
  static ToastThemeData lerp(
    ToastThemeData a,
    ToastThemeData b,
    double t,
  ) {
    return ToastThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      textColor: Color.lerp(a.textColor, b.textColor, t)!,
      descriptionColor:
          Color.lerp(a.descriptionColor, b.descriptionColor, t)!,
      successColor: Color.lerp(a.successColor, b.successColor, t)!,
      errorColor: Color.lerp(a.errorColor, b.errorColor, t)!,
      warningColor: Color.lerp(a.warningColor, b.warningColor, t)!,
      infoColor: Color.lerp(a.infoColor, b.infoColor, t)!,
      borderRadius: a.borderRadius + (b.borderRadius - a.borderRadius) * t,
      padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
      maxWidth: a.maxWidth + (b.maxWidth - a.maxWidth) * t,
      minWidth: a.minWidth + (b.minWidth - a.minWidth) * t,
      messageStyle: TextStyle.lerp(a.messageStyle, b.messageStyle, t)!,
      descriptionStyle:
          TextStyle.lerp(a.descriptionStyle, b.descriptionStyle, t)!,
      shadow: a.shadow,
    );
  }
}

/// An [InheritedWidget] that provides [ToastThemeData] to descendant toasts.
class ToastTheme extends InheritedWidget {
  /// Creates a toast theme provider.
  const ToastTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// The theme data.
  final ToastThemeData data;

  /// Returns the nearest [ToastThemeData] ancestor, or the light default.
  static ToastThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ToastTheme>();
    return widget?.data ?? ToastThemeData.light();
  }

  @override
  bool updateShouldNotify(ToastTheme oldWidget) => data != oldWidget.data;
}
