import 'package:flutter/material.dart';

class PartNumberCard extends StatelessWidget {
  const PartNumberCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 45,
      child: Text(
        movements[index].partNumber,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
