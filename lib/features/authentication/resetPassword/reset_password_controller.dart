// lib/features/authentication/resetPassword/reset_password_controller.dart
import 'package:flutter/material.dart';
import 'package:alp_shoes_secondbrand_mobile/data/services/auth_service.dart';

class ResetPasswordController extends ChangeNotifier {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> resetPassword(BuildContext context, String email, String otp) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      errorMessage = "Password dan konfirmasi harus diisi";
      isLoading = false;
      notifyListeners();
      return;
    }
    if (password.length < 6) {
      errorMessage = "Password minimal 6 karakter";
      isLoading = false;
      notifyListeners();
      return;
    }
    if (password != confirmPassword) {
      errorMessage = "Password dan konfirmasi tidak cocok";
      isLoading = false;
      notifyListeners();
      return;
    }

    final result = await AuthService().resetPassword(email, otp, password);

    isLoading = false;
    if (result['success']) {
      successMessage = result['message'];
      // Navigasi ke login (atau tampilkan pesan sukses & auto redirect)
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
