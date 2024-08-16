import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';

class InventoryContainerCard extends StatelessWidget {
  const InventoryContainerCard({
    super.key,
    required this.parts,
    required this.index,
  });

  final List<PartNumber> parts;
  final int index;

  // COLORS
  static const redBackground = Color(0xFFF28585);
  static const yellowBackground = Color(0xFFFFBB64);
  static const greenBackground = Color(0xFF9ADE7B);

  @override
  Widget build(BuildContext context) {
    int quantity = int.parse(parts[index].quantity);
    int min = int.parse(parts[index].min);
    int max = int.parse(parts[index].max);

    double minRatio = max * 0.20;
    double maxRatio = max * 0.10;
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          decoration: BoxDecoration(
            color: quantity >= max || quantity <= min
                ? redBackground
                : quantity >= min && quantity <= minRatio + min ||
                        quantity <= max && quantity >= max - maxRatio
                    ? yellowBackground
                    : greenBackground,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
