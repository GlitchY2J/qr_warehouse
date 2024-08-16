import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';

class InventoryMeasureCard extends StatelessWidget {
  const InventoryMeasureCard({
    super.key,
    required this.parts,
    required this.index,
  });

  final List<PartNumber> parts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 50,
      child: Text(
        parts[index].measure,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white70,
        ),
      ),
    );
  }
}
