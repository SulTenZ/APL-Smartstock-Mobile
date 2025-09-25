// lib/data/services/audit_log_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';

class AuditLogService {
  Future<Map<String, dynamic>> getAuditLogs({
    int page = 1,
    int limit = 20,
    String? productId,
  }) async {
    final token = await SharedPrefs.getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    final queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (productId != null) 'productId': productId,
    };

    final uri = Uri.parse(ApiEndpoint.auditLogs).replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengambil data audit log');
    }
  }
}