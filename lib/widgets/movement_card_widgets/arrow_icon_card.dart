import 'package:flutter/material.dart';

class ArrowIconCard extends StatelessWidget {
  const ArrowIconCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 330,
      child: movements[index].type == "Entrada"
          ? const Icon(
              Icons.arrow_circle_down,
              size: 50,
            )
          : const Icon(
              Icons.arrow_circle_up,
              size: 50,
            ),
    );
  }
}
