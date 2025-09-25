// lib/data/services/graph_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/api_endpoint.dart';
import '../api/api_constant.dart';
import '../../utils/shared_preferences.dart';

class GraphService {
  /// GET /api/graph/profit-report
  /// Query optional: startDate=YYYY-MM-DD, endDate=YYYY-MM-DD
  Future<Map<String, dynamic>> getProfitReport({
    String? startDate,
    String? endDate,
  }) async {
    final token = await SharedPrefs.getToken();

    // pastikan sudah ada ApiEndpoint.graphProfitReport
    final base = Uri.parse(ApiEndpoint.graphProfitReport);
    final params = <String, String>{};
    if (startDate != null && startDate.isNotEmpty) params['startDate'] = startDate;
    if (endDate != null && endDate.isNotEmpty) params['endDate'] = endDate;

    final uri = base.replace(queryParameters: params.isEmpty ? null : params);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header, // harus memuat Content-Type: application/json
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as Map<String, dynamic>;
    } else {
      final err = _safeJson(response.body);
      throw Exception(err?['message'] ?? 'Gagal mengambil data grafik profit');
    }
  }

  Map<String, dynamic>? _safeJson(String body) {
    try {
      final parsed = jsonDecode(body);
      return parsed is Map<String, dynamic> ? parsed : null;
    } catch (_) {
      return null;
    }
  }
}
