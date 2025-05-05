// lib/features/splash/splash_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../utils/shared_preferences.dart';

class SplashController {
  Future<void> handleNavigation(BuildContext context) async {
    final token = await SharedPrefs.getToken();
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }
}
