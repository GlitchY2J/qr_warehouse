import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';

class ConfirmWidget extends StatelessWidget {
  const ConfirmWidget({
    super.key,
    required this.partNumber,
    required this.addedQty,
    required this.newQty,
  });

  final PartNumber partNumber;
  final String addedQty;
  final String newQty;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          partNumber.partNumber,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Text(
          partNumber.description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 130),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    partNumber.quantity,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Actual',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    addedQty,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'Movimiento',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.arrow_forward_sharp),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    newQty,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
