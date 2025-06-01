// lib/data/services/stock_batch_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/shared_preferences.dart';

class StockBatchService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Ambil semua stock batch
  Future<List<dynamic>> getAllStockBatches() async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse('$baseUrl/api/stock-batch');

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
    } on SocketException catch (e) {
      print('[ERROR] Network error in getAllStockBatches: $e');
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on HttpException catch (e) {
      print('[ERROR] HTTP error in getAllStockBatches: $e');
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException catch (e) {
      print('[ERROR] Format error in getAllStockBatches: $e');
      throw Exception('Data yang diterima tidak valid.');
    } catch (e) {
      print('[ERROR] Unexpected error in getAllStockBatches: $e');
      throw Exception('Terjadi kesalahan yang tidak terduga.');
    }
  }

  // Ambil detail batch by ID
  Future<Map<String, dynamic>> getStockBatchById(String id) async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse('$baseUrl/api/stock-batch/$id');

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
    } on SocketException catch (e) {
      print('[ERROR] Network error in getStockBatchById: $e');
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on HttpException catch (e) {
      print('[ERROR] HTTP error in getStockBatchById: $e');
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException catch (e) {
      print('[ERROR] Format error in getStockBatchById: $e');
      throw Exception('Data yang diterima tidak valid.');
    } catch (e) {
      print('[ERROR] Unexpected error in getStockBatchById: $e');
      throw Exception('Terjadi kesalahan yang tidak terduga.');
    }
  }

  // Buat batch baru
  Future<Map<String, dynamic>> createStockBatch({
    required String nama,
    required double totalHarga,
    required int jumlahSepatu,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/stock-batch');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = {
      'nama': nama,
      'totalHarga': totalHarga,
      'jumlahSepatu': jumlahSepatu,
    };

    try {
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
    } catch (e) {
      print('[ERROR] createStockBatch: $e');
      rethrow;
    }
  }

  // Update batch
  Future<Map<String, dynamic>> updateStockBatch({
    required String id,
    String? nama,
    double? totalHarga,
    int? jumlahSepatu,
  }) async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse('$baseUrl/api/stock-batch/$id');

      final Map<String, dynamic> requestBody = {};
      if (nama != null) requestBody['nama'] = nama;
      if (totalHarga != null) requestBody['totalHarga'] = totalHarga;
      if (jumlahSepatu != null) requestBody['jumlahSepatu'] = jumlahSepatu;

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
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
      print('[ERROR] updateStockBatch: $e');
      rethrow;
    }
  }

  // Hapus batch
  Future<void> deleteStockBatch(String id) async {
    try {
      final token = await SharedPrefs.getToken();
      final uri = Uri.parse('$baseUrl/api/stock-batch/$id');

      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(timeoutDuration);

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Gagal menghapus batch');
      }
    } catch (e) {
      print('[ERROR] deleteStockBatch: $e');
      rethrow;
    }
  }

  // Ambil detail batch + produk (alias)
  Future<Map<String, dynamic>> getStockBatchWithProducts(String id) async {
    return getStockBatchById(id);
  }

  // Hitung rata-rata harga per sepatu
  double calculateAverageCostPerItem(Map<String, dynamic> batch) {
    final totalHarga = batch['totalHarga']?.toDouble() ?? 0.0;
    final jumlahSepatu = batch['jumlahSepatu']?.toInt() ?? 1;
    return jumlahSepatu > 0 ? totalHarga / jumlahSepatu : 0.0;
  }

  // Ringkasan batch
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
