import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/main_page.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
    required this.widget,
  });

  final MainPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF17153B),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, top: 15),
        child: RichText(
          text: TextSpan(
            text: "Bienvenido, ",
            style: const TextStyle(fontSize: 20),
            children: <TextSpan>[
              TextSpan(
                text: widget.user?.fullName == null
                    ? widget.prefs?.getString("fullName")
                    : widget.user!.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC8ACD6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
