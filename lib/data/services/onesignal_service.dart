// lib/data/services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  // Gunakan pola Singleton agar hanya ada satu instance dari service ini
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  Future<void> init() async {
    // Ambil App ID dari file .env
    final String oneSignalAppId = dotenv.env['ONESIGNAL_APP_ID'] ?? '';

    if (oneSignalAppId.isEmpty) {
      if (kDebugMode) {
        print("🔴 [OneSignal] ERROR: ONESIGNAL_APP_ID is not set in .env file.");
      }
      return;
    }

    // Mengaktifkan log OneSignal untuk debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Inisialisasi OneSignal SDK
    OneSignal.initialize(oneSignalAppId);

    if (kDebugMode) {
      print("✅ [OneSignal] Service Initialized with App ID: $oneSignalAppId");
    }

    // Meminta izin notifikasi kepada pengguna (penting untuk iOS)
    await OneSignal.Notifications.requestPermission(true);
    if (kDebugMode) {
      print("🔔 [OneSignal] Notification permission request sent.");
    }

    // Menambahkan listener untuk notifikasi yang diklik
    OneSignal.Notifications.addClickListener((event) {
      if (kDebugMode) {
        print('🖱️ [OneSignal] Notification clicked: ${event.notification}');
        final additionalData = event.notification.additionalData;
        if (additionalData != null) {
          print('📦 [OneSignal] Additional Data: $additionalData');
          // Di sini Anda bisa menambahkan logika navigasi berdasarkan `type`
          // final type = additionalData['type'];
          // final productId = additionalData['productId'];
          // if (type == 'LOW_STOCK') { ... }
        }
      }
    });
  }

  /// Menetapkan ID pengguna eksternal (email) setelah login berhasil.
  /// Ini menghubungkan perangkat dengan user di sistem Anda.
  Future<void> login(String email) async {
    // Menetapkan externalUserId
    OneSignal.login(email);
    if (kDebugMode) {
      print("👤 [OneSignal] User logged in with external ID: $email");
    }
  }

  /// Menghapus ID pengguna eksternal saat logout.
  Future<void> logout() async {
    OneSignal.logout();
    if (kDebugMode) {
      print("👤 [OneSignal] User logged out.");
    }
  }
}