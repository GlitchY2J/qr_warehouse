import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/pages/splash_screen.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    //this.prefs,
  });
  //final SharedPreferences? prefs;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}
