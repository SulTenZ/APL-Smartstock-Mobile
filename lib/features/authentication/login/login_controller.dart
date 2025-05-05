// lib/features/authentication/login/login_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/auth_service.dart';

class LoginController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();

  Future<void> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final email = emailController.text.trim();
    final password = passwordController.text;

    final result = await _authService.login(email, password);

    isLoading = false;
    notifyListeners();

    if (result['success']) {
      final data = result['data'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('userName', data['user']['nama']);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login gagal')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
