// lib/features/authentication/registerOTP/register_otp_controller.dart
import 'package:flutter/material.dart';
import 'package:alp_shoes_secondbrand_mobile/data/services/auth_service.dart';

class RegisterOtpController extends ChangeNotifier {
  final otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> verifyOtp(BuildContext context, String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await AuthService().verifyOtp(email, otpController.text.trim());

    isLoading = false;
    if (result['success']) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      errorMessage = result['message'];
      notifyListeners();
    }
  }

  Future<void> resendOtp(String email) async {
    final result = await AuthService().resendOtp(email);
    if (!result['success']) {
      errorMessage = result['message'];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
