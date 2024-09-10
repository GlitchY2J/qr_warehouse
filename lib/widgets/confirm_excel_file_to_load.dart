import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/login_page.dart';

class ConfirmExcelFileToLoad extends StatelessWidget {
  const ConfirmExcelFileToLoad({
    super.key,
    required this.list,
    required this.bulkUpdate,
  });

  final List<dynamic> list;
  final Function(List<dynamic>) bulkUpdate;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: const Text("Listado de piezas para Inventario"),
      backgroundColor: const Color(0xFF17153B),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 1000,
            height: 700,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      DataTable(
                        columnSpacing: width <= 1200 ? 100 : 200,
                        columns: const [
                          DataColumn(label: Text("Numero de Parte")),
                          DataColumn(label: Text("Cantidad")),
                          DataColumn(label: Text("PO")),
                          DataColumn(label: Text("SO")),
                        ],
                        rows: list.map((row) {
                          return DataRow(
                            cells: [
                              DataCell(Text(row[0])),
                              DataCell(Text(row[1])),
                              DataCell(Text(row[2])),
                              DataCell(Text(row[3])),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: CustomButton(
                  width: width * 0.2,
                  text: "Cancelar",
                  color: Colors.white,
                  textColor: const Color(0xFF433D8B),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  onTap: () {
                    Navigator.pop(context);
                    list.clear();
                  },
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                ),
                child: CustomButton(
                  width: width * 0.2,
                  text: "Confirmar",
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  onTap: () async {
                    // run batch
                    await bulkUpdate(list);
                    Navigator.pop(context);
                    list.clear();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
