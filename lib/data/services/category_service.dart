// lib/data/services/category_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';
import 'package:flutter/material.dart';

class CategoryService {
  Future<Map<String, dynamic>> getAllCategories({
    String? search,
    int? limit,
    int? page,
  }) async {
    final token = await SharedPrefs.getToken();

    final queryParameters = {
      if (search != null) 'search': search,
      if (limit != null) 'limit': limit.toString(),
      if (page != null) 'page': page.toString(),
    };

    final uri = Uri.parse(ApiEndpoint.categories).replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'data': data['data'],
        'meta': data['meta'],
      };
    } else {
      throw Exception('Gagal mengambil data kategori');
    }
  }

  Future<void> createCategory({
    required String nama,
    required String deskripsi,
    required String productTypeId,
  }) async {
    final url = Uri.parse(ApiEndpoint.categories);
    final token = await SharedPrefs.getToken();

    final response = await http.post(
      url,
      headers: {
        ...ApiConstant.header,
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nama': nama,
        'deskripsi': deskripsi,
        'productTypeId': productTypeId,
      }),
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambah kategori');
    }
  }

  Future<void> updateCategory({
    required String id,
    required String nama,
    required String deskripsi,
    required String productTypeId,
  }) async {
    final url = Uri.parse(ApiEndpoint.categoryById(id));
    final token = await SharedPrefs.getToken();

    debugPrint('Updating category with data:');
    debugPrint('id: $id');
    debugPrint('nama: $nama');
    debugPrint('deskripsi: $deskripsi');
    debugPrint('productTypeId: $productTypeId');

    final response = await http.put(
      url,
      headers: {
        ...ApiConstant.header,
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nama': nama,
        'deskripsi': deskripsi,
        'productTypeId': productTypeId,
      }),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal memperbarui kategori');
    }
  }

  Future<void> deleteCategory(String id) async {
    final url = Uri.parse(ApiEndpoint.categoryById(id));
    final token = await SharedPrefs.getToken();

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menghapus kategori');
    }
  }
}
