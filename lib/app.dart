import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/main_page.dart';
import 'package:qr_warehouse/test/test2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.prefs,
  });
  final SharedPreferences? prefs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //home: const MyApp()
      home: prefs?.getString("username") == null
          ? LoginPage()
          : MainPage(
              prefs: prefs,
            ),
    );
  }
}
