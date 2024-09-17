import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_warehouse/app.dart';
import 'package:qr_warehouse/env.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    windowManager.setResizable(true);
    windowManager.setMinimumSize(const Size(800, 1080));
    windowManager.setMaximumSize(const Size(1920, 1200));
  }

  AppEnvironment.setupEnv(Environment.dev);

  runApp(const App());
}
