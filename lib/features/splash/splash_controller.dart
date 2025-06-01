// lib/features/splash/splash_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/shared_preferences.dart';
import '../home/home_view.dart';

class SplashController {
  static const Duration _splashDuration = Duration(seconds: 2);
  static const Duration _fadeTransitionDuration = Duration(milliseconds: 800);

  Future<void> handleNavigation(BuildContext context) async {
    final token = await SharedPrefs.getToken();
    await Future.delayed(_splashDuration);

    if (context.mounted) {
      if (token != null && token.isNotEmpty) {
        _navigateToHomeWithFade(context);
      } else {
        _navigateToLoginWithFade(context);
      }
    }
  }

  // Navigate to Home with fade transition
  void _navigateToHomeWithFade(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeView(),
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

  // Navigate to Login with fade transition
  void _navigateToLoginWithFade(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          // Replace Container() with your actual LoginView()
          // Example: return const LoginView();
          return Container(
            color: const Color(0xFFF8F9FA),
            child: const Center(
              child: Text(
                'Login View',
                style: TextStyle(fontSize: 24),
              ),
            ),
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

  // Enhanced named route navigation with fade
  void _navigateToNamedRouteWithFade(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          // Create a temporary container that will be replaced
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2C3E50).withOpacity(0.12),
                  const Color(0xFF3498DB).withOpacity(0.06),
                  const Color(0xFFFFFFFF),
                  const Color(0xFFF8F9FA),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          );
        },
        transitionDuration: _fadeTransitionDuration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Schedule navigation to named route after transition starts
          if (animation.status == AnimationStatus.forward) {
            Future.delayed(const Duration(milliseconds: 200), () {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, routeName);
              }
            });
          }
          
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  // Hybrid approach: Direct widget navigation with fallback to named routes
  Future<void> handleNavigationHybrid(BuildContext context) async {
    final token = await SharedPrefs.getToken();
    await Future.delayed(_splashDuration);

    if (context.mounted) {
      if (token != null && token.isNotEmpty) {
        // Navigate directly to HomeView with fade
        _navigateToHomeWithFade(context);
      } else {
        // Use named route for login with fade
        _navigateToNamedRouteWithFade(context, '/login');
      }
    }
  }
}