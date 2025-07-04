// lib/features/authentication/forgotPasswordOTP/forgotPasswordOTP_controller.dart
import 'package:flutter/material.dart';
import 'package:alp_shoes_secondbrand_mobile/data/services/auth_service.dart';

class ForgotPasswordOtpController extends ChangeNotifier {
  final otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> verifyResetOtp(BuildContext context, String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      errorMessage = "Kode OTP harus diisi";
      isLoading = false;
      notifyListeners();
      return;
    }

    final result = await AuthService().verifyResetOtp(email, otp);

    isLoading = false;
    if (result['success']) {
      // Navigasi ke halaman reset password baru, passing email dan otp
      Navigator.pushNamed(
        context,
        '/reset-password',
        arguments: {'email': email, 'otp': otp},
      );
    } else {
      errorMessage = result['message'];
    }
    notifyListeners();
  }

  Future<void> resendResetOtp(String email) async {
    // Memanggil forgotPassword lagi untuk resend OTP
    final result = await AuthService().forgotPassword(email);
    if (!result['success']) {
      errorMessage = result['message'];
      notifyListeners();
    }
  }

  void clearMessage() {
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
