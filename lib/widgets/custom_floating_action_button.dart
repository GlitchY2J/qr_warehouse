import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
  });

  final VoidCallback onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFC8ACD6),
      onPressed: onPressed,
      child: icon,
    );
  }
}
