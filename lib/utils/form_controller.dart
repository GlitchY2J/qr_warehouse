import 'package:http/http.dart' as http;
import 'package:qr_warehouse/http/http_client.dart';

class FormController {
  /// INSERT RECORD
  static Future<Map<String, dynamic>> processData(partNumber, description,
      quantity, location, manufacter, mnfPartNumber) async {
    String values =
        "'$partNumber', '$description', $quantity, '$location', '$manufacter', '$mnfPartNumber'";

    return await DatabaseHelper.post(
        "insert_record.php", {"table": "inventory", "values": values});
  }

  /// GET INVENTORY
  static Future<http.Response> getInventory() async {
    return await DatabaseHelper.get("get_inventory.php");
  }

  /// UPDATE RECORD
  static Future<Map<String, dynamic>> updateRecord(values, condition) async {
    return await DatabaseHelper.post("update_record.php",
        {"table": "inventory", "values": values, "condition": condition});
  }

  /// LOGIN
  static Future<Map<String, dynamic>> loginUser(username, password) async {
    return await DatabaseHelper.login(
        "login.php", {"username": username, "password": password});
  }
}
