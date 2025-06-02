// lib/data/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';

class AuthService {
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
        final email = data['user']['email'];

        await SharedPrefs.saveLoginData(token: token, name: name, email: email);
        await SharedPrefs.debugPrintAll();

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
        return {'success': false, 'message': body['message'] ?? 'Registrasi gagal'};
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
        return {'success': false, 'message': body['message'] ?? 'Verifikasi OTP gagal'};
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
        return {'success': false, 'message': body['message'] ?? 'Gagal mengirim ulang OTP'};
      }
    } catch (e) {
      print("❌ ERROR saat resend OTP: $e");
      return {'success': false, 'message': 'Terjadi kesalahan koneksi'};
    }
  }
}

