import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static const String _baseUrl = 'http://10.30.0.42/Dashboard/qr_warehouse';

  static Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
    return response;
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: data,
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        return json.decode(response.body);
      } on Exception catch (_) {
        return {"error": "true"};
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
