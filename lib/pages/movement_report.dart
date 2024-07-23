import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_warehouse/features/pdf/pdf_converter.dart';

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
  late bool ascending;
  late List<dynamic> filterData;
  int? sortColumnIndex;
  List<DataRow> _rows = [];

  String formatDate(date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    String formatedDate = DateFormat("MM-dd-yyyy HH:mm").format(dateTime);
    return formatedDate;
  }

  fillRowsList() {
    _rows = filterData
        .map((row) => DataRow(cells: [
              DataCell(Text(
                row.partNumber,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )),
              DataCell(Text(
                row.description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )),
              DataCell(Text(
                row.type,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )),
              DataCell(Text(
                row.quantity,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )),
              DataCell(Text(
                row.orderNumber,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )),
              DataCell(Text(
                row.username,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )),
              DataCell(Text(
                formatDate(row.dateTime),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )),
            ]))
        .toList();
  }

  List<List<dynamic>> convertDataTableToList() {
    List<List<dynamic>> data = [];
    for (var row in _rows) {
      List<dynamic> rowData = [];
      for (var cell in row.cells) {
        rowData.add(cell.child is Text ? (cell.child as Text).data : null);
      }
      data.add(rowData);
    }
    return data;
  }

  onSortColumn({required int columnIndex, required bool ascending}) {
    fillRowsList();
    if (columnIndex == 0) {
      setState(() {
        if (ascending) {
          filterData = filterData
            ..sort((a, b) => a.partNumber.compareTo(b.partNumber));
        } else {
          filterData = filterData
            ..sort((a, b) => b.partNumber.compareTo(a.partNumber));
        }
        this.ascending = ascending;
        sortColumnIndex = columnIndex;
      });
    } else if (columnIndex == 1) {
      setState(() {
        if (ascending) {
          filterData = filterData
            ..sort((a, b) => a.description.compareTo(b.description));
        } else {
          filterData = filterData
            ..sort((a, b) => b.description.compareTo(a.description));
        }
        this.ascending = ascending;
        sortColumnIndex = columnIndex;
      });
    } else if (columnIndex == 2) {
      setState(() {
        if (ascending) {
          filterData = filterData..sort((a, b) => a.type.compareTo(b.type));
        } else {
          filterData = filterData..sort((a, b) => b.type.compareTo(a.type));
        }
        this.ascending = ascending;
        sortColumnIndex = columnIndex;
      });
    } else if (columnIndex == 3) {
      setState(() {
        if (ascending) {
          filterData = filterData
            ..sort((a, b) =>
                int.parse(a.quantity).compareTo(int.parse(b.quantity)));
        } else {
          filterData = filterData
            ..sort((a, b) =>
                int.parse(b.quantity).compareTo(int.parse(a.quantity)));
        }
        this.ascending = ascending;
        sortColumnIndex = columnIndex;
      });
    } else if (columnIndex == 4) {
      setState(() {
        if (ascending) {
          filterData = filterData
            ..sort((a, b) =>
                int.parse(a.orderNumber).compareTo(int.parse(b.orderNumber)));
        } else {
          filterData = filterData
            ..sort((a, b) =>
                int.parse(b.orderNumber).compareTo(int.parse(a.orderNumber)));
        }
        this.ascending = ascending;
        sortColumnIndex = columnIndex;
      });
    } else if (columnIndex == 5) {
      setState(() {
        if (ascending) {
          filterData = filterData
            ..sort((a, b) => a.username.compareTo(b.username));
        } else {
          filterData = filterData
            ..sort((a, b) => b.username.compareTo(a.username));
        }
        this.ascending = ascending;
        sortColumnIndex = columnIndex;
      });
    } else if (columnIndex == 6) {
      setState(() {
        if (ascending) {
          filterData = filterData
            ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
        } else {
          filterData = filterData
            ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
        }
        this.ascending = ascending;
        sortColumnIndex = columnIndex;
      });
    }
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  @override
  void initState() {
    filterData = List.of(widget.movementsList);
    fillRowsList();
    ascending = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E236E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E236E),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                /// DATATABLE
                child: Theme(
                  data: Theme.of(context).copyWith(
                      iconTheme: Theme.of(context)
                          .iconTheme
                          .copyWith(color: Colors.black)),
                  child: DataTable(
                    sortAscending: ascending,
                    sortColumnIndex: sortColumnIndex,
                    border: TableBorder.symmetric(
                      inside: const BorderSide(width: 1, color: Colors.black),
                    ),
                    columnSpacing: 100,
                    horizontalMargin: 80,
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

                    /// COLUMNS
                    columns: [
                      DataColumn(
                        label: const Text('Número de Parte'),
                        onSort: (int columnIndex, bool ascending) =>
                            onSortColumn(
                                columnIndex: columnIndex, ascending: ascending),
                      ),
                      DataColumn(
                        label: const Text('Descripción'),
                        onSort: (int columnIndex, bool ascending) =>
                            onSortColumn(
                                columnIndex: columnIndex, ascending: ascending),
                      ),
                      DataColumn(
                        label: const Text('Movimiento'),
                        onSort: (int columnIndex, bool ascending) =>
                            onSortColumn(
                                columnIndex: columnIndex, ascending: ascending),
                      ),
                      DataColumn(
                        label: const Text('Cantidad'),
                        onSort: (int columnIndex, bool ascending) =>
                            onSortColumn(
                                columnIndex: columnIndex, ascending: ascending),
                      ),
                      DataColumn(
                        label: const Text('Orden'),
                        onSort: (int columnIndex, bool ascending) =>
                            onSortColumn(
                                columnIndex: columnIndex, ascending: ascending),
                      ),
                      DataColumn(
                        label: const Text('Usuario'),
                        onSort: (int columnIndex, bool ascending) =>
                            onSortColumn(
                                columnIndex: columnIndex, ascending: ascending),
                      ),
                      DataColumn(
                        label: const Text('Fecha y Hora'),
                        onSort: (int columnIndex, bool ascending) =>
                            onSortColumn(
                                columnIndex: columnIndex, ascending: ascending),
                      ),
                    ],
                    rows: _rows,
                  ),
                ),
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC8ACD6),
        onPressed: () => PDFConverter.generatePdf(convertDataTableToList()),
        child: const Icon(
          Icons.save,
          color: Color(0xFF17153B),
        ),
      ),
    );
  }
}
