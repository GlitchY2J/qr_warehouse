import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/utils/formatters.dart';

class InventoryQuantityCard extends StatelessWidget {
  const InventoryQuantityCard({
    super.key,
    required this.parts,
    required this.index,
  });

  final List<PartNumber> parts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 50,
      child: Text(
        '${Formatters.integerOrDouble(parts[index].quantity, parts[index].measure)} ${parts[index].measure}',
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white70,
        ),
      ),
    );
  }
}
