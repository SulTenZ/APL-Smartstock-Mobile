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
      queryParameters: {
        'year': year.toString(),
        'month': month.toString(),
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
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengambil data laporan');
    }
  }

  String getFinancialSummaryPdfUrl({
    required int year,
    required int month,
  }) {
    // URL ini harus sudah termasuk token jika endpoint-nya dilindungi middleware
    // Untuk sekarang kita asumsikan bisa diakses langsung setelah login
    final uri = Uri.parse(ApiEndpoint.downloadFinancialSummary).replace(
      queryParameters: {
        'year': year.toString(),
        'month': month.toString(),
      },
    );
    return uri.toString();
  }
}