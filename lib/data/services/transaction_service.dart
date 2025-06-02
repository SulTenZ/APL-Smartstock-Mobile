// lib/data/services/transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';

class TransactionService {
  // Buat transaksi baru
  Future<Map<String, dynamic>> createTransaction({
    String? customerId,
    required String paymentMethod,
    double diskon = 0,
    String? catatan,
    required List<Map<String, dynamic>> items,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.transactions);

    final bodyPayload = {
      if (customerId != null) 'customerId': customerId,
      'paymentMethod': paymentMethod,
      'diskon': diskon,
      if (catatan != null) 'catatan': catatan,
      'items': items,
    };

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
      body: jsonEncode(bodyPayload),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final errorData = jsonDecode(response.body);
      if (errorData['errors'] != null) {
        final errors = errorData['errors'].map((e) => e['msg']).join(', ');
        throw Exception(errors);
      }
      throw Exception(errorData['message'] ?? 'Gagal membuat transaksi');
    }
  }

  // Ambil semua transaksi
  Future<List<dynamic>> getAllTransactions() async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.transactions);

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
  }

  // Ambil transaksi berdasarkan ID
  Future<Map<String, dynamic>> getTransactionById(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.transactionById(id));

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
    final uri = Uri.parse(ApiEndpoint.transactionById(id));

    final bodyPayload = {
      if (customerId != null) 'customerId': customerId,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (diskon != null) 'diskon': diskon,
      if (catatan != null) 'catatan': catatan,
      'items': items,
    };

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
      body: jsonEncode(bodyPayload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else if (response.statusCode == 404) {
      throw Exception('Transaksi tidak ditemukan');
    } else {
      final errorData = jsonDecode(response.body);
      if (errorData['errors'] != null) {
        final errors = errorData['errors'].map((e) => e['msg']).join(', ');
        throw Exception(errors);
      }
      throw Exception(errorData['message'] ?? 'Gagal memperbarui transaksi');
    }
  }

  // Hapus transaksi
  Future<void> deleteTransaction(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.transactionById(id));

    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw Exception('Transaksi tidak ditemukan');
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menghapus transaksi');
      }
    }
  }

  // Laporan penjualan
  Future<Map<String, dynamic>> getSalesReport({
    required String startDate,
    required String endDate,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('${ApiEndpoint.salesReport}?startDate=$startDate&endDate=$endDate');

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
  }

  // Laporan profit
  Future<Map<String, dynamic>> getProfitReport({
    required String startDate,
    required String endDate,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('${ApiEndpoint.profitReport}?startDate=$startDate&endDate=$endDate');

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
  }
}