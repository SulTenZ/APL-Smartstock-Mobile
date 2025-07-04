// lib/features/authentication/forgotPassword/forgotPassword_controller.dart
import 'package:flutter/material.dart';
import 'package:alp_shoes_secondbrand_mobile/data/services/auth_service.dart';

class ForgotPasswordController extends ChangeNotifier {
  final emailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> sendForgotPassword(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final email = emailController.text.trim();

    if (email.isEmpty) {
      errorMessage = "Email harus diisi";
      isLoading = false;
      notifyListeners();
      return;
    }

    final result = await AuthService().forgotPassword(email);

    isLoading = false;
    if (result['success']) {
      successMessage = result['message'];
      // Navigasi ke halaman input OTP reset password
      Navigator.pushNamed(
        context,
        '/forgot-password-otp',
        arguments: email,
      );
    } else {
      errorMessage = result['message'];
    }
    notifyListeners();
  }

  void clearMessage() {
    errorMessage = null;
    successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
