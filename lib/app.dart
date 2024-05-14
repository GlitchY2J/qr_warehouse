import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/pages/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MainPage(),
    );
  }
}
