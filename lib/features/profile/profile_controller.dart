// lib/features/profile/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/shared_preferences.dart';

class ProfileController extends ChangeNotifier {
  bool isLoggingOut = false;

  Future<void> logout(BuildContext context) async {
    isLoggingOut = true;
    notifyListeners();

    await SharedPrefs.clear();

    isLoggingOut = false;
    notifyListeners();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<String?> getUserEmail() async {
    return await SharedPrefs.getEmail();
  }

  Future<String?> getUserName() async {
    return await SharedPrefs.getName();
  }
}