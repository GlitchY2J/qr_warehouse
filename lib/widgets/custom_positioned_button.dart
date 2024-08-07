import 'package:flutter/material.dart';

class CustomPositionedButton extends StatelessWidget {
  const CustomPositionedButton({
    super.key,
    required this.onTap,
    required this.text,
    this.padding = const EdgeInsets.all(20),
    this.top,
    this.left,
    this.width,
  });

  final VoidCallback onTap;
  final String text;
  final EdgeInsets? padding;
  final double? top;
  final double? left;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        width: width,
        child: Container(
          width: double.infinity,
          padding: padding,
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
