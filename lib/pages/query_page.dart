import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/edit_page.dart';
import 'package:qr_warehouse/pages/qr_scan_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/widgets/custom_card.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';

class QueryPage extends StatefulWidget {
  const QueryPage({super.key});

  @override
  State<QueryPage> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  String? scannedData;
  bool showDataTable = false;
  List allParts = [];
  List parts = [];
  PartNumber partModel = PartNumber(partNumber: '', description: '');

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    await getPartNumbers();
  }

  void openScannerScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScanPage()),
    );

    if (result != null) {
      partModel.partNumber = result;
      searchPartNumber();
    }
  }

  Future<void> getPartNumbers() async {
    http.Response response = await FormController.getInventory();
    setState(() {
      allParts = jsonDecode(response.body);
      parts = allParts;
    });
  }

  void updatePartNumber(String text) {
    partModel.partNumber = text;
    searchPartNumber();
  }

  void updateDescription(String text) {
    partModel.description = text;
    searchPartNumber();
  }

  void searchPartNumber() {
    final suggestions = allParts.where((part) {
      final partNumber = part["partnumber"].toLowerCase();
      final description = part["description"].toLowerCase();

      return (partNumber.contains(partModel.partNumber.toLowerCase()) &&
              description.contains(partModel.description.toLowerCase())) ||
          (description.contains(partModel.description.toLowerCase()) &&
              partNumber.contains(partModel.partNumber.toLowerCase()));
    }).toList();

    setState(() => parts = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
          child: Center(
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            // Part Number
                            flex: 3,
                            child: SizedBox(
                              width: 600,
                              child: TextFormField(
                                onChanged: (String value) {
                                  updatePartNumber(value);
                                },
                                decoration: const InputDecoration(
                                  labelText: "Número de Parte",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 56),
                          Expanded(
                            // QR Button
                            flex: 1,
                            child: CustomIconButton(
                              onTap: openScannerScreen,
                              icon: Icons.qr_code,
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Description
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          onChanged: (String value) {
                            updateDescription(value);
                          },
                          decoration: const InputDecoration(
                            labelText: "Descripción",
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Search Button
                      SizedBox(
                        width: 600.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          onPressed: () {
                            asyncInit();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh'),
                        ),
                      ),
                      const SizedBox(height: 48),

                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: parts.length < 20 ? parts.length : 20,
                        itemBuilder: (context, index) {
                          return Material(
                            type: MaterialType.transparency,
                            elevation: 1.0,
                            color: Colors.transparent,
                            shadowColor: Colors.grey[50],
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: CustomCard(
                                  partnumber:
                                      parts[index]["partnumber"].toString(),
                                  location: parts[index]["location"].toString(),
                                  description:
                                      parts[index]["description"].toString(),
                                  qty: parts[index]["quantity"].toString(),
                                  partsList: parts[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
