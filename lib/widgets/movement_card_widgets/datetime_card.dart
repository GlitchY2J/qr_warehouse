import 'package:flutter/material.dart';
import 'package:qr_warehouse/utils/formatters.dart';

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 30,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          Formatters.formatDateFromString(movements[index].dateTime),
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
