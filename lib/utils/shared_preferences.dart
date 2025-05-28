// lib/utils/shared_preferences.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Keys untuk SharedPreferences
  static const String _tokenKey = 'token';
  static const String _nameKey = 'nama';
  static const String _emailKey = 'email';
  static const String _isLoggedInKey = 'is_logged_in';

  // Token methods
  static Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setString(_tokenKey, token);
      
      // Set logged in status
      if (result) {
        await prefs.setBool(_isLoggedInKey, true);
      }
      
      return result;
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  static Future<bool> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_tokenKey);
      
      // Update logged in status
      if (result) {
        await prefs.setBool(_isLoggedInKey, false);
      }
      
      return result;
    } catch (e) {
      print('Error clearing token: $e');
      return false;
    }
  }

  // User data methods
  static Future<bool> saveUser(String name, String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final nameResult = await prefs.setString(_nameKey, name);
      final emailResult = await prefs.setString(_emailKey, email);
      
      return nameResult && emailResult;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  static Future<String?> getEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error getting email: $e');
      return null;
    }
  }

  static Future<String?> getName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_nameKey);
    } catch (e) {
      print('Error getting name: $e');
      return null;
    }
  }

  // Login status methods
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasToken = prefs.getString(_tokenKey) != null;
      final loginStatus = prefs.getBool(_isLoggedInKey) ?? false;
      
      return hasToken && loginStatus;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  static Future<bool> setLoginStatus(bool status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_isLoggedInKey, status);
    } catch (e) {
      print('Error setting login status: $e');
      return false;
    }
  }

  // Get all user data at once
  static Future<Map<String, String?>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      return {
        'name': prefs.getString(_nameKey),
        'email': prefs.getString(_emailKey),
        'token': prefs.getString(_tokenKey),
      };
    } catch (e) {
      print('Error getting user data: $e');
      return {
        'name': null,
        'email': null,
        'token': null,
      };
    }
  }

  // Save complete login data
  static Future<bool> saveLoginData({
    required String token,
    required String name,
    required String email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final tokenResult = await prefs.setString(_tokenKey, token);
      final nameResult = await prefs.setString(_nameKey, name);
      final emailResult = await prefs.setString(_emailKey, email);
      final statusResult = await prefs.setBool(_isLoggedInKey, true);
      
      return tokenResult && nameResult && emailResult && statusResult;
    } catch (e) {
      print('Error saving login data: $e');
      return false;
    }
  }

  // Clear all data
  static Future<bool> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  // Clear only user-related data (keep app settings)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final tokenResult = await prefs.remove(_tokenKey);
      final nameResult = await prefs.remove(_nameKey);
      final emailResult = await prefs.remove(_emailKey);
      final statusResult = await prefs.setBool(_isLoggedInKey, false);
      
      return tokenResult && nameResult && emailResult && statusResult;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  // Check if specific data exists
  static Future<bool> hasToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking token existence: $e');
      return false;
    }
  }

  static Future<bool> hasUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_nameKey);
      final email = prefs.getString(_emailKey);
      
      return name != null && email != null && name.isNotEmpty && email.isNotEmpty;
    } catch (e) {
      print('Error checking user data existence: $e');
      return false;
    }
  }

  // Debug method to print all stored data
  static Future<void> debugPrintAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      print('=== SharedPreferences Debug ===');
      for (String key in keys) {
        final value = prefs.get(key);
        print('$key: $value');
      }
      print('==============================');
    } catch (e) {
      print('Error printing debug data: $e');
    }
  }
}