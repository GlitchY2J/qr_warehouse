import 'package:flutter/material.dart';

class InventoryContainerCard extends StatelessWidget {
  const InventoryContainerCard({
    super.key,
  });

  // COLORS
  static const backgroundColor = Color(0xFF433D8B);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
