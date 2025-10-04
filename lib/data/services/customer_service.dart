// lib/data/services/customer_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constant.dart';
import '../api/api_endpoint.dart';
import '../../utils/shared_preferences.dart';

class CustomerService {
  Future<List<dynamic>> getAllCustomers() async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.customers);

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil data customer');
    }
  }

  Future<Map<String, dynamic>> getCustomerById(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.customerById(id));

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil detail customer');
    }
  }

  Future<Map<String, dynamic>> createCustomer({
    required String nama,
    // String? email,
    String? phone,
    // String? alamat,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.customers);

    final bodyPayload = {
      'nama': nama,
      // if (email != null && email.trim().isNotEmpty) 'email': email,
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone,
      // if (alamat != null && alamat.trim().isNotEmpty) 'alamat': alamat,
    };

    print('[DEBUG] Create customer payload: $bodyPayload');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
      body: jsonEncode(bodyPayload),
    );

    print('[DEBUG] Status code: ${response.statusCode}');
    print('[DEBUG] Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      try {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Gagal menambahkan customer');
      } catch (e) {
        throw Exception('Gagal menambahkan customer: ${response.body}');
      }
    }
  }

  Future<Map<String, dynamic>> updateCustomer({
    required String id,
    String? nama,
    String? email,
    String? phone,
    // String? alamat,
  }) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.customerById(id));

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        ...ApiConstant.header,
      },
      body: jsonEncode({
        if (nama != null) 'nama': nama,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        // if (alamat != null) 'alamat': alamat,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal memperbarui customer');
    }
  }

  Future<void> deleteCustomer(String id) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse(ApiEndpoint.customerById(id));

    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menghapus customer');
    }
  }

  Future<Map<String, dynamic>?> findExistingCustomer(String value) async {
    final customers = await getAllCustomers();
    for (final c in customers) {
      if (c['email']?.toLowerCase() == value.toLowerCase() ||
          c['phone'] == value) {
        return c;
      }
    }
    return null;
  }
}