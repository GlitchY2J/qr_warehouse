import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';

class InventoryDescriptionCard extends StatelessWidget {
  const InventoryDescriptionCard({
    super.key,
    required this.parts,
    required this.index,
  });

  final List<PartNumber> parts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 50,
      child: SizedBox(
        width: 330,
        child: Text(
          parts[index].description,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
