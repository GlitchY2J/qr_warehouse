import 'package:flutter/material.dart';

class ContainerCard extends StatelessWidget {
  const ContainerCard({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: movements[index].type == "Entrada"
                ? const Color(0xFFA1C398)
                : const Color(0xFFFA7070),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
