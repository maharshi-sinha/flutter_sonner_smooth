/// Type and position enums for toast notifications.
library;

/// The visual type of a toast, determining its icon and accent color.
enum ToastType {
  /// A plain toast with no icon.
  neutral,

  /// A toast with a green checkmark icon.
  success,

  /// A toast with a red alert icon.
  error,

  /// A toast with an amber warning icon.
  warning,

  /// A toast with a blue info icon.
  info,

  /// A toast with a spinning loader. Does not auto-dismiss.
  loading,
}

/// Where on the screen a toast appears.
enum ToastPosition {
  /// Top-left corner.
  topLeft,

  /// Top center.
  topCenter,

  /// Top-right corner.
  topRight,

  /// Bottom-left corner.
  bottomLeft,

  /// Bottom center.
  bottomCenter,

  /// Bottom-right corner.
  bottomRight,
}

/// The direction a toast can be swiped to dismiss.
enum SwipeDirection {
  /// Automatically determined based on [ToastPosition].
  auto,

  /// Swipe left or right to dismiss.
  horizontal,

  /// Swipe up or down to dismiss.
  vertical,

  /// Swiping is disabled.
  none,
}

/// The lifecycle status of a toast.
enum ToastStatus {
  /// The toast is animating into view.
  entering,

  /// The toast is fully visible and counting down its duration.
  visible,

  /// The toast is animating out of view.
  exiting,

  /// The toast has been removed.
  dismissed,
}
