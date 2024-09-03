import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_warehouse/app.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/main_page.dart';
import 'package:qr_warehouse/widgets/astro_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late SharedPreferences prefs;

  Future<void> asyncInit() async {
    // shared preferences
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    asyncInit();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => prefs.getString("username") == null
            ? LoginPage()
            : MainPage(
                prefs: prefs,
              ),
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF2E236E),
        body: Center(
          child: AstroLogo(width: 100),
        ),
      ),
    );
  }
}
