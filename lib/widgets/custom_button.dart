import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 60),
    this.width = double.infinity,
    required this.text,
    required this.onTap,
    this.color = const Color(0xFF433D8B),
    this.textColor = Colors.white,
  });

  final EdgeInsets padding;
  final double? width;
  final String text;
  final Function() onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            //color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            color: color,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onTap,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
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
