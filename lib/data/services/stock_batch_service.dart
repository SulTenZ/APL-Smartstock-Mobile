// lib/data/services/stock_batch_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';

class StockBatchService {
  static const Duration timeoutDuration = Duration(seconds: 30);

  Future<List<dynamic>> getAllStockBatches() async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse(ApiEndpoint.stockBatches);

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Gagal mengambil data batch');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Data yang diterima tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak terduga.');
    }
  }

  Future<Map<String, dynamic>> getStockBatchById(String id) async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse(ApiEndpoint.stockBatchById(id));

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else if (response.statusCode == 404) {
        throw Exception('Batch tidak ditemukan');
      } else {
        throw Exception('Gagal mengambil detail batch');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail batch.');
    }
  }

  Future<Map<String, dynamic>> createStockBatch({
    required String nama,
    required double totalHarga,
    required int jumlahSepatu,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.stockBatches);

    final headers = {
      'Authorization': 'Bearer $token',
      ...ApiConstant.header,
    };

    final body = {
      'nama': nama,
      'totalHarga': totalHarga,
      'jumlahSepatu': jumlahSepatu,
    };

    final response = await http
        .post(uri, headers: headers, body: jsonEncode(body))
        .timeout(timeoutDuration);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Gagal membuat batch');
    }
  }

  Future<Map<String, dynamic>> updateStockBatch({
    required String id,
    String? nama,
    double? totalHarga,
    int? jumlahSepatu,
  }) async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse(ApiEndpoint.stockBatchById(id));

      final requestBody = {
        if (nama != null) 'nama': nama,
        if (totalHarga != null) 'totalHarga': totalHarga,
        if (jumlahSepatu != null) 'jumlahSepatu': jumlahSepatu,
      };

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          ...ApiConstant.header,
        },
        body: jsonEncode(requestBody),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Gagal memperbarui batch');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memperbarui batch.');
    }
  }

  Future<void> deleteStockBatch(String id) async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse(ApiEndpoint.stockBatchById(id));

      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(timeoutDuration);

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Gagal menghapus batch');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus batch.');
    }
  }

  Future<Map<String, dynamic>> getStockBatchWithProducts(String id) async {
    return getStockBatchById(id);
  }

  double calculateAverageCostPerItem(Map<String, dynamic> batch) {
    final totalHarga = batch['totalHarga']?.toDouble() ?? 0.0;
    final jumlahSepatu = batch['jumlahSepatu']?.toInt() ?? 1;
    return jumlahSepatu > 0 ? totalHarga / jumlahSepatu : 0.0;
  }

  Map<String, dynamic> getBatchSummary(Map<String, dynamic> batch) {
    final products = batch['products'] as List<dynamic>? ?? [];
    final totalProducts = products.length;
    final totalHarga = batch['totalHarga']?.toDouble() ?? 0.0;
    final jumlahSepatu = batch['jumlahSepatu']?.toInt() ?? 0;
    final averageCost = calculateAverageCostPerItem(batch);

    return {
      'totalProducts': totalProducts,
      'totalHarga': totalHarga,
      'jumlahSepatu': jumlahSepatu,
      'averageCostPerItem': averageCost,
      'remainingSlots': jumlahSepatu - totalProducts,
    };
  }
}