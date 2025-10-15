import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';

// --- IMPORT BARU ---
import 'onesignal_service.dart';

class AuthService {
  // --- TAMBAHAN ---
  final OneSignalService _oneSignalService = OneSignalService();
  // --- AKHIR TAMBAHAN ---

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiEndpoint.login);

    try {
      final response = await http.post(
        url,
        headers: ApiConstant.header,
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("🔍 STATUS: ${response.statusCode}");
      print("🔍 BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final name = data['user']['nama'];
        final userEmail = data['user']['email'];

        await SharedPrefs.saveLoginData(
            token: token, name: name, email: userEmail);
        await SharedPrefs.debugPrintAll();

        // --- SINKRONISASI ONESIGNAL SAAT LOGIN ---
        await _oneSignalService.login(userEmail);
        // --- AKHIR SINKRONISASI ---

        return {'success': true, 'data': data};
      } else {
        final body = jsonDecode(response.body);
        return {'success': false, 'message': body['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      print("❌ ERROR saat login: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }

  // ... sisa kode di file ini tetap sama ...
  Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
  ) async {
    final url = Uri.parse(ApiEndpoint.register);

    try {
      final response = await http.post(
        url,
        headers: ApiConstant.header,
        body: jsonEncode({'nama': nama, 'email': email, 'password': password}),
      );

      print("📝 STATUS: ${response.statusCode}");
      print("📝 BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': body['message']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Registrasi gagal'
        };
      }
    } catch (e) {
      print("❌ ERROR saat register: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final url = Uri.parse(ApiEndpoint.verifyOtp);

    try {
      final response = await http.post(
        url,
        headers: ApiConstant.header,
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print("✅ STATUS: ${response.statusCode}");
      print("✅ BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': body['message']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Verifikasi OTP gagal'
        };
      }
    } catch (e) {
      print("❌ ERROR saat verifikasi OTP: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }

  Future<Map<String, dynamic>> resendOtp(String email) async {
    final url = Uri.parse(ApiEndpoint.resendOtp);

    try {
      final response = await http.post(
        url,
        headers: ApiConstant.header,
        body: jsonEncode({'email': email}),
      );

      print("📨 STATUS: ${response.statusCode}");
      print("📨 BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': body['message']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal mengirim ulang OTP'
        };
      }
    } catch (e) {
      print("❌ ERROR saat resend OTP: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }

  // 1. Lupa Password (Kirim OTP reset ke email)
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse(ApiEndpoint.forgotPassword);

    try {
      final response = await http.post(
        url,
        headers: ApiConstant.header,
        body: jsonEncode({'email': email}),
      );

      print("🔑 [ForgotPassword] STATUS: ${response.statusCode}");
      print("🔑 [ForgotPassword] BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': body['message']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal mengirim kode reset password'
        };
      }
    } catch (e) {
      print("❌ ERROR saat forgotPassword: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }

  // 2. Verifikasi OTP Reset Password
  Future<Map<String, dynamic>> verifyResetOtp(String email, String otp) async {
    final url = Uri.parse(ApiEndpoint.verifyResetOtp);

    try {
      final response = await http.post(
        url,
        headers: ApiConstant.header,
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print("🔎 [VerifyResetOtp] STATUS: ${response.statusCode}");
      print("🔎 [VerifyResetOtp] BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': body['message']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Verifikasi OTP gagal'
        };
      }
    } catch (e) {
      print("❌ ERROR saat verifyResetOtp: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }

  // 3. Reset Password (setelah OTP valid)
  Future<Map<String, dynamic>> resetPassword(
      String email, String otp, String newPassword) async {
    final url = Uri.parse(ApiEndpoint.resetPassword);

    try {
      final response = await http.post(
        url,
        headers: ApiConstant.header,
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
      );

      print("🔒 [ResetPassword] STATUS: ${response.statusCode}");
      print("🔒 [ResetPassword] BODY: ${response.body}");

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': body['message']};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Reset password gagal'
        };
      }
    } catch (e) {
      print("❌ ERROR saat resetPassword: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }
}