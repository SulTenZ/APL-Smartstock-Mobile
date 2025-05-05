// lib/features/authentication/registerOTP/register_otp_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_otp_controller.dart';

class RegisterOtpView extends StatelessWidget {
  final String email;
  const RegisterOtpView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterOtpController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verifikasi OTP'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Consumer<RegisterOtpController>(
          builder: (context, controller, _) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan kode OTP yang telah dikirim ke:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Kode OTP',
                      border: OutlineInputBorder(),
                      errorText: controller.errorMessage,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.verifyOtp(context, email),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: controller.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Verifikasi'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => controller.resendOtp(email),
                    child: const Text('Kirim Ulang OTP'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
