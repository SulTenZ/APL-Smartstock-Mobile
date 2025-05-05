import 'package:flutter/material.dart';
import 'package:alp_shoes_secondbrand_mobile/data/services/auth_service.dart';

class RegisterController extends ChangeNotifier {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> register(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    final result = await AuthService().register(nama, email, password);

    isLoading = false;
    notifyListeners();

    if (result['success']) {
      Navigator.pushNamed(
        context,
        '/register-otp',
        arguments: email,
      );
    } else {
      errorMessage = result['message'] ?? 'Registrasi gagal';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
