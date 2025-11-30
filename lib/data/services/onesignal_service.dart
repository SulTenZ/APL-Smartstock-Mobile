// lib/data/services/onesignal_service.dart
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
        print(
          "🔴 [OneSignal] ERROR: ONESIGNAL_APP_ID is not set in .env file.",
        );
      }
      return;
    }

    // Mengaktifkan log OneSignal untuk debugging (opsional, matikan saat release)
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Inisialisasi OneSignal SDK
    OneSignal.initialize(oneSignalAppId);

    if (kDebugMode) {
      print("✅ [OneSignal] Service Initialized with App ID: $oneSignalAppId");
    }

    // Meminta izin notifikasi kepada pengguna
    await OneSignal.Notifications.requestPermission(true);
    if (kDebugMode) {
      print("🔔 [OneSignal] Notification permission request sent.");
    }

    // Menambahkan listener untuk notifikasi yang diklik
    OneSignal.Notifications.addClickListener((event) {
      if (kDebugMode) {
        print(
          '🖱️ [OneSignal] Notification clicked: ${event.notification.title}',
        );
        final additionalData = event.notification.additionalData;
        if (additionalData != null) {
          print('📦 [OneSignal] Additional Data: $additionalData');
          // Tambahkan logika navigasi di sini jika diperlukan
          // GlobalKey<NavigatorState>().currentState?.pushNamed(...)
        }
      }
    });
  }

  /// PENTING: Panggil ini setelah user berhasil Login di aplikasi Anda.
  /// Ini menghubungkan device ini dengan Email user di server OneSignal.
  Future<void> login(String email) async {
    OneSignal.login(email); // External ID set to Email
    if (kDebugMode) {
      print("👤 [OneSignal] User logged in with external ID: $email");
    }
  }

  /// PENTING: Panggil ini saat user Logout dari aplikasi.
  /// Ini memutuskan hubungan device dengan user tersebut agar tidak terima notifikasi lagi.
  Future<void> logout() async {
    OneSignal.logout();
    if (kDebugMode) {
      print("👤 [OneSignal] User logged out.");
    }
  }
}
