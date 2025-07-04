// lib/features/authentication/forgotPasswordOTP/forgotPasswordOTP_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_form.dart';
import 'forgotPasswordOTP_controller.dart';

class ForgotPasswordOtpView extends StatelessWidget {
  final String email;
  const ForgotPasswordOtpView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordOtpController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verifikasi OTP Reset Password'),
        ),
        body: Consumer<ForgotPasswordOtpController>(
          builder: (context, controller, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Masukkan kode OTP yang telah dikirim ke email:',
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
                  CustomFormField(
                    label: "Kode OTP",
                    hintText: "Masukkan Kode OTP",
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    errorText: controller.errorMessage,
                    onChanged: (val) => controller.clearMessage(),
                  ),
                  const SizedBox(height: 24),
                  if (controller.errorMessage != null)
                    Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: controller.isLoading ? "Memverifikasi..." : "Verifikasi",
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.verifyResetOtp(context, email),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => controller.resendResetOtp(email),
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
