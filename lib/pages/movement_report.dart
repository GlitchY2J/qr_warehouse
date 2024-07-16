import 'dart:io';

import 'package:flutter/material.dart';

class MovementReport extends StatefulWidget {
  const MovementReport({
    super.key,
    required this.movementsList,
  });

  final List<dynamic> movementsList;

  @override
  State<MovementReport> createState() => _MovementReportState();
}

class _MovementReportState extends State<MovementReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E236E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E236E),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.symmetric(
                  inside: const BorderSide(width: 2, color: Colors.black),
                ),
                columnSpacing: 200,
                headingTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                columns: const [
                  DataColumn(label: Text('Número de Parte')),
                  DataColumn(label: Text('Movimiento')),
                  DataColumn(label: Text('Cantidad')),
                  DataColumn(label: Text('Orden')),
                  DataColumn(label: Text('Usuario')),
                ],
                rows: widget.movementsList
                    .map((row) => DataRow(cells: [
                          DataCell(Text(
                            row['partnumber'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )),
                          DataCell(Text(
                            row['type'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )),
                          DataCell(Text(
                            row['quantity'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )),
                          DataCell(Text(
                            row['order_number'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )),
                          DataCell(Text(
                            row['username'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          )),
                        ]))
                    .toList(),
              )),
        ),
      ),
    );
  }
}
