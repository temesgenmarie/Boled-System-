import 'package:flutter/material.dart';

class AppAnimations {
  // Duration constants
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Curves
  static const Curve easeInOutCubic = Cubic(0.645, 0.045, 0.355, 1.0);
  static const Curve easeOutCubic = Cubic(0.215, 0.61, 0.355, 1.0);
  static const Curve easeInCubic = Cubic(0.55, 0.055, 0.675, 0.19);
  
  // Slide transition
  static SlideTransition slideTransition({
    required Animation<Offset> animation,
    required Widget child,
    Offset begin = const Offset(1.0, 0.0),
  }) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: begin, end: Offset.zero).chain(
          CurveTween(curve: easeOutCubic),
        ),
      ),
      child: child,
    );
  }
  
  // Fade transition
  static FadeTransition fadeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation.drive(
        Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: easeOutCubic),
        ),
      ),
      child: child,
    );
  }
}
