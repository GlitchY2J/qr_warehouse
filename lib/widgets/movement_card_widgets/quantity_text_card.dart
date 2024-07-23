import 'package:flutter/material.dart';

class QuantityTextCard extends StatelessWidget {
  const QuantityTextCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 34,
      left: 380,
      child: Text(
        movements[index].quantity,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
