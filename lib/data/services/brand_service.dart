// lib/data/services/brand_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';

class BrandService {
  Future<Map<String, dynamic>> getAllBrands({
    String? search,
    int? page,
    int? limit,
  }) async {
    final token = await SharedPrefs.getToken();

    final uri = Uri.parse(ApiEndpoint.brands).replace(
      queryParameters: {
        if (search != null) 'search': search,
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'data': data['data'], 'meta': data['meta']};
    } else {
      throw Exception('Gagal mengambil data brand');
    }
  }

  Future<void> createBrand({
    required String nama,
    String? deskripsi,
    File? imageFile,
  }) async {
    final token = await SharedPrefs.getToken();
    if (token == null) throw Exception('Token tidak ditemukan');
    final uri = Uri.parse(ApiEndpoint.brands);

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nama'] = nama;

    if (deskripsi != null) request.fields['deskripsi'] = deskripsi;

    if (imageFile != null) {
      final mimeType = lookupMimeType(imageFile.path);
      final type = mimeType?.split('/');
      if (type != null && type.length == 2) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType(type[0], type[1]),
          ),
        );
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambah brand');
    }
  }

  Future<void> updateBrand({
    required String id,
    required String nama,
    String? deskripsi,
    File? imageFile,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.brandById(id));

    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nama'] = nama;

    if (deskripsi != null) request.fields['deskripsi'] = deskripsi;

    if (imageFile != null) {
      final mimeType = lookupMimeType(imageFile.path);
      final type = mimeType?.split('/');
      if (type != null && type.length == 2) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType(type[0], type[1]),
          ),
        );
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal memperbarui brand');
    }
  }

  Future<void> deleteBrand(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.brandById(id));

    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menghapus brand');
    }
  }
}
