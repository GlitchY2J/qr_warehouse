import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';

class InventoryLocationCard extends StatelessWidget {
  const InventoryLocationCard({
    super.key,
    required this.parts,
    required this.index,
  });

  final List<PartNumber> parts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 70,
      left: 50,
      child: Text(
        parts[index].location,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
      ),
    );
  }
}
