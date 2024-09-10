import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_warehouse/app.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //debug checker
  if (kDebugMode) {
    print('debug mode');
  }

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    windowManager.setResizable(true);
    windowManager.setMinimumSize(const Size(800, 1080));
    windowManager.setMaximumSize(const Size(1920, 1200));
  }

  runApp(const App());
}
