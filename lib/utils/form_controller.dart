import 'package:get/get_connect/connect.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/http/http_client.dart';

class FormController {
  static Future<Map<String, dynamic>> processData(partNumber, description,
      quantity, location, manufacter, mnfPartNumber) async {
    String values =
        "'$partNumber', '$description', $quantity, '$location', '$manufacter', '$mnfPartNumber'";

    return await DatabaseHelper.post(
        "insert_record.php", {"table": "inventory", "values": values});
  }

  static Future<http.Response> getInventory() async {
    return await DatabaseHelper.get("get_inventory.php");
  }
}
