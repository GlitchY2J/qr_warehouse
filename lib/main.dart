import 'package:flutter/material.dart';
import 'package:qr_warehouse/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString("username");
  runApp(App(username: username));
}
