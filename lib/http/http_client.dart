import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/foundation.dart';

class DatabaseHelper {
  // choose between testing or production database
  static const String _baseUrl = kDebugMode
      ? 'http://10.30.0.42/Dashboard/qr_warehouse/testing'
      : 'http://10.30.0.42/Dashboard/qr_warehouse';

  /// GET METHOD
  static Future<http.Response> get(String endpoint, dynamic data) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: data));
    return response;
  }

  /// POST METHOD
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: data,
    );
    return _handleResponse(response);
  }

  /// UPDATE METHOD
  static Future<Map<String, dynamic>> update(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: data,
    );
    return _handleResponse(response);
  }

  // BULK UPDATE METHOD
  static Future<Map<String, dynamic>> bulkUpdate(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// LOGIN METHOD
  static Future<http.Response> login(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: data,
    );
    return response;
  }

  /// MOVEMENTS METHOD
  static Future<http.Response> getMovements(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));

    return response;
  }

  /// HANDLE RESPONSE METHOD
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
