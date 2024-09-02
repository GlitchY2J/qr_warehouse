import 'package:flutter/material.dart';
import 'package:qr_warehouse/app.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // window manager
  await windowManager.ensureInitialized();

  WindowOptions options = const WindowOptions(
    size: Size(1920, 1080),
  );

  windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.maximize();
    await windowManager.focus();
  });

  // shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(App(
    prefs: prefs,
  ));
}
