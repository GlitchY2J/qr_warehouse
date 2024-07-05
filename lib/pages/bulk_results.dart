import 'package:flutter/material.dart';
import 'package:qr_warehouse/utils/form_controller.dart';

class BulkResults extends StatefulWidget {
  final List<List<dynamic>> partsList;
  const BulkResults({
    super.key,
    required this.partsList,
  });

  @override
  State<BulkResults> createState() => _BulkResultsState();
}

class _BulkResultsState extends State<BulkResults> {
  String textData = "Loading...";

  @override
  void initState() {
    super.initState();
  }

  List<List<String>> formatListToSql() {
    List<List<String>> queryList = [];
    List<String> statementList = [];
    List<String> conditionList = [];

    // For each list inside partsList, get partnumber and qty
    for (List<dynamic> list in widget.partsList.sublist(1)) {
      statementList.add("quantity = quantity + ${list[2].toString()}");
      conditionList.add("partnumber = '${list[0]}';");
    }

    queryList.add(statementList);
    queryList.add(conditionList);

    return queryList;
  }

  showSnackBar(myContext) {
    /// Creating snackbar
    SnackBar snackBar;

    // Set snackbar content
    snackBar = const SnackBar(content: Text("Registro Completo."));

    /// Showing message
    if (myContext.mounted) {
      ScaffoldMessenger.of(myContext).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 5,
                  columns: widget.partsList.first
                      .map((column) =>
                          DataColumn(label: Text(column.toString())))
                      .toList(),
                  rows: widget.partsList.sublist(1).map((row) {
                    return DataRow(
                      cells: row
                          .map((cell) => DataCell(Text(cell.toString())))
                          .toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: FloatingActionButton.extended(
                heroTag: "btn1",
                backgroundColor: const Color(0xFFFFFFFF),
                foregroundColor: const Color(0xFF000000),
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 30),
            SizedBox(
              width: 120,
              child: FloatingActionButton.extended(
                heroTag: "btn2",
                backgroundColor: const Color(0xFF448AFF),
                onPressed: () async {
                  List<List<String>> queryList = formatListToSql();

                  List<String> valuesList = queryList[0];
                  List<String> conditionsList = queryList[1];

                  for (int i = 0; i < valuesList.length; i++) {
                    Map<String, dynamic> result =
                        await FormController.updateRecord(
                            valuesList[i], conditionsList[i]);
                  }

                  showSnackBar(context);
                },
                label: const Text('Confirmar'),
              ),
            ),
          ],
        ));
  }
}
