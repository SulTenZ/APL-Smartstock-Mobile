// lib/features/authentication/login/login_view.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_form.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Consumer<LoginController>(
              builder: (context, controller, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Halo,", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text("Selamat datang!", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 24),

                    // Email Field
                    CustomFormField(
                      label: "Email",
                      hintText: "Masukkan Email",
                      controller: controller.emailController, onChanged: (val) {  },
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    CustomFormField(
                      label: "Password",
                      hintText: "Masukkan Password",
                      controller: controller.passwordController,
                      obscureText: true, onChanged: (val) {  },
                    ),

                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Lupa Password?", style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Button
                    CustomButton(
                      text: controller.isLoading ? "Loading..." : "Sign In",
                      onPressed: controller.isLoading ? null : () => controller.login(context),
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Belum mempunyai akun? ",
                          children: [
                            TextSpan(
                              text: "Daftar sekarang",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/register');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
