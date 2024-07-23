import 'package:flutter/material.dart';

class OrderNumberCard extends StatelessWidget {
  const OrderNumberCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 30,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            movements[index].orderNumber,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
