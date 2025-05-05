// lib/features/authentication/register/register_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_form.dart';
import 'register_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Akun'),
        ),
        body: Consumer<RegisterController>(
          builder: (context, controller, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomFormField(
                    label: "Nama",
                    hintText: "Masukkan Nama",
                    controller: controller.namaController, onChanged: (val) {  },
                  ),
                  const SizedBox(height: 16),
                  CustomFormField(
                    label: "Email",
                    hintText: "Masukkan Email",
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress, onChanged: (val) {  },
                  ),
                  const SizedBox(height: 16),
                  CustomFormField(
                    label: "Password",
                    hintText: "Masukkan Password",
                    controller: controller.passwordController,
                    obscureText: true, onChanged: (val) {  },
                  ),
                  const SizedBox(height: 24),
                  if (controller.errorMessage != null)
                    Text(
                      controller.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 8),
                  CustomButton(
                    text: controller.isLoading ? "Loading..." : "Daftar",
                    onPressed: controller.isLoading
                        ? null
                        : () => controller.register(context),
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
