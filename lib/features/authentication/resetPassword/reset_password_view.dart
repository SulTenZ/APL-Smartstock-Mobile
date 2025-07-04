// lib/features/authentication/resetPassword/reset_password_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_form.dart';
import 'reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;
  final String otp;
  const ResetPasswordView({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password Baru'),
        ),
        body: Consumer<ResetPasswordController>(
          builder: (context, controller, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Buat password baru untuk akun Anda.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  CustomFormField(
                    label: "Password Baru",
                    hintText: "Masukkan Password Baru",
                    controller: controller.passwordController,
                    obscureText: true,
                    errorText: controller.errorMessage,
                    onChanged: (val) => controller.clearMessage(),
                  ),
                  const SizedBox(height: 16),
                  CustomFormField(
                    label: "Konfirmasi Password",
                    hintText: "Ulangi Password Baru",
                    controller: controller.confirmPasswordController,
                    obscureText: true,
                    errorText: null,
                    onChanged: (val) => controller.clearMessage(),
                  ),
                  const SizedBox(height: 24),
                  if (controller.errorMessage != null)
                    Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (controller.successMessage != null)
                    Text(
                      controller.successMessage!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: controller.isLoading
                        ? "Memproses..."
                        : "Simpan Password Baru",
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.resetPassword(context, email, otp),
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