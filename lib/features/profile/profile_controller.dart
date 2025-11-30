// lib/features/profile/profile_controller.dart
import 'package:flutter/material.dart';
import '../../utils/shared_preferences.dart';

// 1. IMPORT SERVICE ONESIGNAL
import '../../data/services/onesignal_service.dart';

class ProfileController extends ChangeNotifier {
  bool isLoggingOut = false;
  bool isLoadingProfile = false;

  String? _cachedName;
  String? _cachedEmail;

  // 2. BUAT INSTANCE ONESIGNAL SERVICE
  final OneSignalService _oneSignalService = OneSignalService();

  // Getter untuk data yang disimpan
  String? get cachedName => _cachedName;
  String? get cachedEmail => _cachedEmail;

  Future<void> initializeProfile() async {
    if (_cachedName == null || _cachedEmail == null) {
      await _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    isLoadingProfile = true;
    notifyListeners();

    try {
      final name = await SharedPrefs.getName();
      final email = await SharedPrefs.getEmail();

      _cachedName = name ?? 'Pengguna';
      _cachedEmail = email ?? 'email@example.com';
    } catch (e) {
      print('❌ Error loading user data: $e');
      _cachedName = 'Error memuat nama';
      _cachedEmail = 'Error memuat email';
    }

    isLoadingProfile = false;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    _cachedName = null;
    _cachedEmail = null;
    await _loadUserData();
  }

  Future<void> logout(BuildContext context) async {
    if (isLoggingOut) return;

    isLoggingOut = true;
    notifyListeners();

    try {
      // 3. PANGGIL LOGOUT ONESIGNAL SEBELUM CLEAR DATA
      // Ini menghapus External ID dari perangkat ini
      await _oneSignalService.logout();

      await SharedPrefs.clear();
      _cachedName = null;
      _cachedEmail = null;

      isLoggingOut = false;
      notifyListeners();

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      isLoggingOut = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal keluar dari aplikasi. Coba lagi.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<bool> updateProfile(String name, String email) async {
    try {
      await SharedPrefs.saveUser(name, email);
      _cachedName = name;
      _cachedEmail = email;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await SharedPrefs.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  String getNameInitial() {
    if (_cachedName != null && _cachedName!.isNotEmpty) {
      return _cachedName![0].toUpperCase();
    }
    return 'U';
  }

  @override
  void dispose() {
    _cachedName = null;
    _cachedEmail = null;
    super.dispose();
  }
}
