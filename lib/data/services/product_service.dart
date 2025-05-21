// lib/data/services/product_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../../utils/shared_preferences.dart';

class ProductService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

Future<Map<String, dynamic>> getAllProducts({
  String? search,
  int? page,
  int? limit,
  String? brandId,
  int? categoryId,
  String? productTypeId,
}) async {
  final token = await SharedPrefs.getToken();
  final uri = Uri.parse('$baseUrl/api/product').replace(
    queryParameters: {
      if (search != null) 'search': search,
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (brandId != null) 'brandId': brandId,
      if (categoryId != null) 'categoryId': categoryId.toString(),
      if (productTypeId != null) 'productTypeId': productTypeId,
    },
  );

  final response = await http.get(
    uri,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return {'data': data['data'], 'pagination': data['pagination']};
  } else {
    throw Exception('Gagal mengambil data produk');
  }
}

  Future<Map<String, dynamic>> getProductById(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product/$id');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil detail produk');
    }
  }

  Future<Map<String, dynamic>> createProduct({
    required String nama,
    String? deskripsi,
    required double hargaBeli,
    required double hargaJual,
    required int categoryId,
    required int brandId,
    required String productTypeId,
    int? minStock,
    String? kondisi,
    String? stockBatchId,
    File? imageFile,
    List<Map<String, dynamic>>? sizes,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['nama'] = nama
      ..fields['hargaBeli'] = hargaBeli.toString()
      ..fields['hargaJual'] = hargaJual.toString()
      ..fields['categoryId'] = categoryId.toString()
      ..fields['brandId'] = brandId.toString()
      ..fields['productTypeId'] = productTypeId;

    if (deskripsi != null) request.fields['deskripsi'] = deskripsi;
    if (minStock != null) request.fields['minStock'] = minStock.toString();
    if (kondisi != null) request.fields['kondisi'] = kondisi.toUpperCase();
    if (stockBatchId != null) request.fields['stockBatchId'] = stockBatchId;

    if (sizes != null && sizes.isNotEmpty) {
      final cleanSizes = sizes.map((s) => {
        'sizeId': s['sizeId'],
        'quantity': s['quantity'],
      }).toList();
      request.fields['sizes'] = jsonEncode(cleanSizes);
    }

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

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambah produk');
    }
  }

  Future<Map<String, dynamic>> updateProduct({
    required String id,
    String? nama,
    String? deskripsi,
    double? hargaBeli,
    double? hargaJual,
    int? categoryId,
    int? brandId,
    String? productTypeId,
    int? minStock,
    String? kondisi,
    String? stockBatchId,
    File? imageFile,
    List<Map<String, dynamic>>? sizes,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product/$id');

    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token';

    if (nama != null) request.fields['nama'] = nama;
    if (deskripsi != null) request.fields['deskripsi'] = deskripsi;
    if (hargaBeli != null) request.fields['hargaBeli'] = hargaBeli.toString();
    if (hargaJual != null) request.fields['hargaJual'] = hargaJual.toString();
    if (categoryId != null) request.fields['categoryId'] = categoryId.toString();
    if (brandId != null) request.fields['brandId'] = brandId.toString();
    if (productTypeId != null) request.fields['productTypeId'] = productTypeId;
    if (minStock != null) request.fields['minStock'] = minStock.toString();
    if (kondisi != null) request.fields['kondisi'] = kondisi;
    if (stockBatchId != null) request.fields['stockBatchId'] = stockBatchId;
    if (sizes != null) request.fields['sizes'] = jsonEncode(sizes);

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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal memperbarui produk');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product/$id');

    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menghapus produk');
    }
  }

  // Get products with low stock
  Future<List<dynamic>> getLowStockProducts() async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product/low-stock');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil produk dengan stok rendah');
    }
  }

  // Add size to a product
  Future<Map<String, dynamic>> addProductSize({
    required String productId,
    required String sizeId,
    required int quantity,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product/$productId/sizes');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'sizeId': sizeId, 'quantity': quantity}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menambahkan ukuran produk');
    }
  }

  // Update product size stock (berdasarkan productSizeId, bukan kombinasi productId & sizeId)
  Future<Map<String, dynamic>> updateProductSize({
    required String productSizeId,
    required int quantity,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product-size/$productSizeId');

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'quantity': quantity}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(
        body['message'] ?? 'Gagal memperbarui stok ukuran produk',
      );
    }
  }

  // Delete product size
  Future<void> deleteProductSize({
    required String productId,
    required String sizeId,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product/$productId/sizes/$sizeId');

    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menghapus ukuran produk');
    }
  }

  // Sync all product stocks
  Future<Map<String, dynamic>> syncAllProductStocks() async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/product/sync-stocks');

    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menyinkronkan stok produk');
    }
  }
}
