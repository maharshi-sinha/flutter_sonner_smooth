/// Spring physics constants for toast motion.
///
/// All toast animations use [SpringSimulation] — never cubic beziers.
library;

import 'package:flutter/physics.dart';

/// Calibrated spring descriptions for toast animations.
class ToastSpring {
  ToastSpring._();

  /// Enter animation: slightly underdamped for a lively settle.
  static const SpringDescription enter = SpringDescription(
    mass: 1.0,
    stiffness: 180.0,
    damping: 20.0,
  );

  /// Exit animation: stiffer for a snappy departure.
  static const SpringDescription exit = SpringDescription(
    mass: 1.0,
    stiffness: 240.0,
    damping: 24.0,
  );

  /// Stack reordering: medium stiffness for smooth shifting.
  static const SpringDescription stackShift = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 22.0,
  );
}
