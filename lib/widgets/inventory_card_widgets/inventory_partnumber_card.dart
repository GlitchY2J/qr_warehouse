import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';

class InventoryPartNumberCard extends StatelessWidget {
  const InventoryPartNumberCard({
    super.key,
    required this.parts,
    required this.index,
  });

  final List<PartNumber> parts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 50,
      child: Text(
        parts[index].partNumber,
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
