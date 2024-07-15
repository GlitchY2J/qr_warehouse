import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.text,
    required this.icon,
    required this.height,
    required this.width,
    required this.onPressed,
    this.iconPadding = 0,
  });

  final String text;
  final IconData icon;
  final double height;
  final double width;
  final double iconPadding;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF433D8B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            )),
        onPressed: onPressed,
        icon: Padding(
          padding: EdgeInsets.only(left: iconPadding),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
