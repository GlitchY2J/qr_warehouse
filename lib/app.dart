import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/main_page.dart';

class App extends StatelessWidget {
  const App({super.key, this.username});
  final String? username;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: username == null ? LoginPage() : const MainPage(),
    );
  }
}
