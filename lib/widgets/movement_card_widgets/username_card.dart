import 'package:flutter/material.dart';

class UsernameCard extends StatelessWidget {
  const UsernameCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 30,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          movements[index].username,
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
