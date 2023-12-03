// Navigation functions
import 'package:flutter/material.dart';

// No Transition
class NoTransitionTo extends PageRouteBuilder {
  final Widget screen;

  NoTransitionTo({required this.screen}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
  );
}

// Fade transition
class FadeTransitionTo extends PageRouteBuilder {
  final Widget screen;

  FadeTransitionTo({required this.screen}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}