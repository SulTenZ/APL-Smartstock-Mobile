// lib/data/services/product_type_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/shared_preferences.dart';

class ProductTypeService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<List<dynamic>> getAllProductTypes() async {
    final url = Uri.parse('$baseUrl/api/product-types');
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawData = data['data'] ?? [];
      return rawData.map((item){
        return Map<String, dynamic>.from(item);
      }).toList();
    } else {
      throw Exception('Gagal mengambil data tipe produk');
    }
  }

  Future<void> createProductType(String name) async {
    final url = Uri.parse('$baseUrl/api/product-types');
    final token = await SharedPrefs.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambah tipe produk');
    }
  }

  Future<void> updateProductType(String id, String name) async {
    final url = Uri.parse('$baseUrl/api/product-types/$id');
    final token = await SharedPrefs.getToken();

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal memperbarui tipe produk');
    }
  }

  Future<void> deleteProductType(String id) async {
    final url = Uri.parse('$baseUrl/api/product-types/$id');
    final token = await SharedPrefs.getToken();

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menghapus tipe produk');
    }
  }
}
