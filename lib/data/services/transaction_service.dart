// lib/data/services/transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/shared_preferences.dart';

class TransactionService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  // Buat transaksi baru
  Future<Map<String, dynamic>> createTransaction({
    String? customerId,
    required String paymentMethod,
    double diskon = 0,
    String? catatan,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/transaction');

    final bodyPayload = {
      if (customerId != null) 'customerId': customerId,
      'paymentMethod': paymentMethod,
      'diskon': diskon,
      if (catatan != null) 'catatan': catatan,
      'items': items,
    };

    print('[DEBUG] Create transaction payload: $bodyPayload');
    print('[DEBUG] POST $uri');
    
    try {
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyPayload),
      );
      print('[DEBUG] Status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData['errors'] != null && errorData['errors'].isNotEmpty) {
          // Handle validation errors
          final errors = errorData['errors'].map((e) => e['msg']).join(', ');
          throw Exception(errors);
        } else {
          throw Exception(errorData['message'] ?? 'Gagal membuat transaksi');
        }
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal membuat transaksi: Respons tidak valid');
      }
      rethrow;
    }
  }

  // Ambil semua transaksi
  Future<List<dynamic>> getAllTransactions() async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/transaction');

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil data transaksi');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal mengambil data transaksi: Respons tidak valid');
      }
      rethrow;
    }
  }

  // Ambil transaksi berdasarkan ID
  Future<Map<String, dynamic>> getTransactionById(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/transaction/$id');

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else if (response.statusCode == 404) {
        throw Exception('Transaksi tidak ditemukan');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil detail transaksi');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal mengambil detail transaksi: Respons tidak valid');
      }
      rethrow;
    }
  }

  // Update transaksi
  Future<Map<String, dynamic>> updateTransaction({
    required String id,
    String? customerId,
    String? paymentMethod,
    double? diskon,
    String? catatan,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/transaction/$id');

    final bodyPayload = {
      if (customerId != null) 'customerId': customerId,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (diskon != null) 'diskon': diskon,
      if (catatan != null) 'catatan': catatan,
      'items': items,
    };

    print('[DEBUG] Update transaction payload: $bodyPayload');
    print('[DEBUG] PUT $uri');

    try {
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyPayload),
      );
      print('[DEBUG] Status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else if (response.statusCode == 404) {
        throw Exception('Transaksi tidak ditemukan');
      } else {
        final errorData = jsonDecode(response.body);
        if (errorData['errors'] != null && errorData['errors'].isNotEmpty) {
          // Handle validation errors
          final errors = errorData['errors'].map((e) => e['msg']).join(', ');
          throw Exception(errors);
        } else {
          throw Exception(errorData['message'] ?? 'Gagal memperbarui transaksi');
        }
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal memperbarui transaksi: Respons tidak valid');
      }
      rethrow;
    }
  }

  // Hapus transaksi
  Future<void> deleteTransaction(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$baseUrl/api/transaction/$id');

    try {
      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Transaksi tidak ditemukan');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menghapus transaksi');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal menghapus transaksi: Respons tidak valid');
      }
      rethrow;
    }
  }

  // Ambil laporan penjualan
  Future<Map<String, dynamic>> getSalesReport({
    required String startDate,
    required String endDate,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(
      '$baseUrl/api/transaction/report/sales?startDate=$startDate&endDate=$endDate',
    );

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil laporan penjualan');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal mengambil laporan penjualan: Respons tidak valid');
      }
      rethrow;
    }
  }

  // Ambil laporan profit
  Future<Map<String, dynamic>> getProfitReport({
    required String startDate,
    required String endDate,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(
      '$baseUrl/api/transaction/report/profit?startDate=$startDate&endDate=$endDate',
    );

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil laporan profit');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Gagal mengambil laporan profit: Respons tidak valid');
      }
      rethrow;
    }
  }
}