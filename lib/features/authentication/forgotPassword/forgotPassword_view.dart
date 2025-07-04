// lib/features/authentication/forgotPassword/forgotPassword_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_form.dart';
import 'forgotPassword_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lupa Password'),
        ),
        body: Consumer<ForgotPasswordController>(
          builder: (context, controller, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Masukkan email yang terdaftar untuk menerima kode reset password:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  CustomFormField(
                    label: "Email",
                    hintText: "Email",
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: controller.errorMessage,
                    onChanged: (val) {
                      controller.clearMessage();
                    },
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
                        ? "Mengirim..."
                        : "Kirim Kode Reset",
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.sendForgotPassword(context),
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
