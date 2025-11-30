// lib/data/services/report_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/shared_preferences.dart';
import '../api/api_endpoint.dart';
import '../api/api_constant.dart';

class ReportService {
  Future<Map<String, dynamic>> getFinancialSummary({
    required int year,
    required int month,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.financialSummary).replace(
      queryParameters: {'year': year.toString(), 'month': month.toString()},
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', ...ApiConstant.header},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengambil data laporan');
    }
  }

  // PERUBAHAN DI SINI:
  // Method diubah menjadi async (Future) untuk mengambil token dari SharedPrefs
  Future<String> getFinancialSummaryPdfUrl({
    required int year,
    required int month,
  }) async {
    // 1. Ambil token user yang sedang login
    final token = await SharedPrefs.getToken();

    // 2. Tempelkan token sebagai query parameter 'token'
    final uri = Uri.parse(ApiEndpoint.downloadFinancialSummary).replace(
      queryParameters: {
        'year': year.toString(),
        'month': month.toString(),
        'token': token ?? '', // Token dikirim lewat URL agar browser bisa akses
      },
    );

    return uri.toString();
  }
}
