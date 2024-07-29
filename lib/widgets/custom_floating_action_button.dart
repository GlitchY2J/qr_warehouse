import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/movement_report.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.selectedMovementList,
    required this.getMovements,
  });

  final List<dynamic> selectedMovementList;
  final Function getMovements;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFC8ACD6),
      onPressed: () => {
        Navigator.of(context)
            .push(CupertinoPageRoute(
          builder: (context) => MovementReport(
            movementsList: selectedMovementList,
          ),
        ))
            .then((value) {
          getMovements();
        })
      },
      child: const Icon(
        Icons.table_chart,
        color: Color(0xFF17153B),
      ),
    );
  }
}
