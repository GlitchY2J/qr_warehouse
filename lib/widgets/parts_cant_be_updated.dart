import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/login_page.dart';

class PartsCantBeUpdated extends StatelessWidget {
  const PartsCantBeUpdated({
    super.key,
    required this.list,
  });

  final List<dynamic> list;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: const Text(
          "Los siguientes números de parte no se pudieron actualizar..."),
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
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    DataTable(
                      dataTextStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: CustomButton(
                    text: "Enterado",
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    onTap: () async {
                      Navigator.pop(context);
                      list.clear();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
