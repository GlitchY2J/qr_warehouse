import 'package:flutter/material.dart';

class CustomIconButton2 extends StatelessWidget {
  const CustomIconButton2({
    this.borderRadius = 4,
    this.splashColor = const Color.fromRGBO(3, 155, 229, 1),
    this.alignment = Alignment.center,
    this.backgroundColor = const Color(0xff323537),
    required this.icon,
    this.iconColor = Colors.white,
    this.iconSize = 32,
    required this.onTap,
    super.key,
  });

  final double borderRadius;
  final Color splashColor;
  final Alignment alignment;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: splashColor,
          onTap: onTap,
          child: Container(
            width: double.infinity,
            alignment: alignment,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius),
                ),
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
