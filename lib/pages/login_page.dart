import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/user.dart';
import 'package:qr_warehouse/pages/main_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/app_text.dart';
import 'package:qr_warehouse/widgets/astro_logo.dart';
import 'package:qr_warehouse/widgets/astrophysics_logo.dart';
import 'package:qr_warehouse/widgets/custom_positioned_button.dart';
import 'package:qr_warehouse/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  loginRequestToDatabase(context) async {
    // Get username and password
    String username = usernameController.text;
    String password = passwordController.text;

    // Request access to database
    http.Response response = await FormController.loginUser(username, password);

    if (response.statusCode == 200 && response.body != "null") {
      User user = User.fromJson(jsonDecode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", user.username);
      prefs.setString("password", user.password);
      prefs.setString("fullName", user.fullName);
      prefs.setString("userType", user.userType);

      if (context.mounted) {
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => MainPage(user: user)));
      }
    } else {
      /// Create error message
      SnackBar snackBar;
      snackBar =
          const SnackBar(content: Text("Usuario o contraseña incorrecta."));

      /// Show message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double desktopPadding = screenWidth * 0.35;
    final double tabletPaddit = screenWidth * 0.25;
    final double mobilePadding = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30
              // horizontal: screenWidth < 800
              //     ? mobilePadding
              //     : screenWidth > 800 && screenWidth < 1200
              //         ? tabletPaddit
              //         : desktopPadding,
              ),
          child: Center(
            child: SizedBox(
              width: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),

                  // Logo
                  screenWidth < 800
                      ? const AstroLogo(
                          color: Colors.white,
                          width: 120,
                        )
                      : const AstrophysicsLogo(color: Colors.white, width: 650),
                  const SizedBox(height: 180),

                  // Login text
                  AppText(
                    text: 'Ingresa tu usuario y contraseña',
                    color: Colors.grey[500],
                    size: 16,
                  ),
                  const SizedBox(height: 30),

                  // Username TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: CustomTextField(
                      controller: usernameController,
                      hintText: "Usuario",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      onSubmitted: (_) {
                        loginRequestToDatabase(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: CustomTextField(
                      controller: passwordController,
                      hintText: "Contraseña",
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      onSubmitted: (_) {
                        loginRequestToDatabase(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // sign in button
                  CustomButton(
                    text: 'Iniciar Sesión',
                    onTap: () => loginRequestToDatabase(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 60),
    this.width,
    required this.text,
    required this.onTap,
  });

  final EdgeInsets padding;
  final double? width;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            //color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: const Color(0xFF433D8B),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
