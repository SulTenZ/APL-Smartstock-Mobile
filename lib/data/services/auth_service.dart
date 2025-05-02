import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({ 'email': email, 'password': password }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return { 'success': true, 'token': data['token'], 'user': data['user'] };
    } else {
      return { 'success': false, 'message': data['message'] };
    }
  }
}