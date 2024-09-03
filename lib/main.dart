import 'package:flutter/material.dart';
import 'package:qr_warehouse/app.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //debug checker
  if (kDebugMode) {
    print('debug mode');
  }

  runApp(const App());
}
