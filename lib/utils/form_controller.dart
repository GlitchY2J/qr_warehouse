import 'package:http/http.dart' as http;
import 'package:qr_warehouse/http/http_client.dart';

class FormController {
  /// INSERT RECORD
  static Future<Map<String, dynamic>> insertRecords(table, values) async {
    return await DatabaseHelper.post(
        "insert_record.php", {"table": table, "values": values});
  }

  /// GET TABLE
  static Future<http.Response> getTable(table, conditions) async {
    return await DatabaseHelper.get(
        "get_table.php", {"table": table, "conditions": conditions});
  }

  /// UPDATE RECORD
  static Future<Map<String, dynamic>> updateRecord(values, condition) async {
    return await DatabaseHelper.post("update_record.php",
        {"table": "inventory", "values": values, "condition": condition});
  }

  /// LOGIN
  static Future<http.Response> loginUser(username, password) async {
    return await DatabaseHelper.login(
        "login.php", {"username": username, "password": password});
  }

  /// GET MOVEMENTS DATA
  static Future<http.Response> getMovements() async {
    return await DatabaseHelper.getMovements("get_movements.php");
  }
}
