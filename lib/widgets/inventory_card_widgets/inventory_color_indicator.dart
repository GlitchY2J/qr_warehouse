import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';

class InventoryColorIndicator extends StatelessWidget {
  const InventoryColorIndicator({
    super.key,
    required this.parts,
    required this.index,
  });

  final List<PartNumber> parts;
  final int index;

  // COLORS
  static const defaultBackground = Color(0xFF433D8B);
  static const redBackground = Color(0xFFF28585);
  static const yellowBackground = Color(0xFFFFBB64);
  static const greenBackground = Color(0xFF9ADE7B);

  @override
  Widget build(BuildContext context) {
    double quantity = double.parse(parts[index].quantity);
    double min = double.parse(parts[index].min);
    double max = double.parse(parts[index].max);

    double minRatio = max * 0.20;
    double maxRatio = max * 0.10;
    return Positioned(
      top: 12,
      right: 43,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: min == max
              ? defaultBackground
              : quantity >= max || quantity <= min
                  ? redBackground
                  : quantity >= min && quantity <= minRatio + min ||
                          quantity <= max && quantity >= max - maxRatio
                      ? yellowBackground
                      : greenBackground,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
