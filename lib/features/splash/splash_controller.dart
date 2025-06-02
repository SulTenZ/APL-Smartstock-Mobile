// lib/features/splash/splash_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/shared_preferences.dart';

class SplashController {
  static const Duration _splashDuration = Duration(seconds: 2);
  static const Duration _fadeTransitionDuration = Duration(milliseconds: 800);

  Future<void> handleNavigation(BuildContext context) async {
    final token = await SharedPrefs.getToken();
    await Future.delayed(_splashDuration);

    if (context.mounted) {
      final targetRoute = (token != null && token.isNotEmpty) ? '/home' : '/login';
      _navigateToNamedRouteWithFade(context, targetRoute);
    }
  }

  void _navigateToNamedRouteWithFade(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          // Placeholder sementara selama transisi
          Future.delayed(const Duration(milliseconds: 200), () {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, routeName);
            }
          });
          return Container(
            color: const Color(0xFFF8F9FA),
          );
        },
        transitionDuration: _fadeTransitionDuration,
        reverseTransitionDuration: _fadeTransitionDuration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }
}