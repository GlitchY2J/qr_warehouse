import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/bulk_results.dart';
import 'package:qr_warehouse/pages/qr_scan_page.dart';
import 'package:qr_warehouse/utils/encrypt_data.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/widgets/custom_card.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/custom_textfield.dart';

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

  encryptUrl(String url) {
    const String key = "58648FEEE6F2A342";
    String encryptedUrl = EncryptData.encryptAES(url, key);

    debugPrint(encryptedUrl);
  }

  String decryptUrl(String encryptedString) {
    const String key = "58648FEEE6F2A342";
    String decryptedUrl = EncryptData.decryptAES(encryptedString, key);

    return decryptedUrl;
  }

  Future<List<List<dynamic>>> fetchTextData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return const CsvToListConverter().convert(response.body);
    } else {
      return [];
    }
  }

  formatCSVToList(String url) async {
    String decryptedUrl = decryptUrl(url);
    //String decryptedUrl = decryptUrl(url);
    List<List<dynamic>> partsList = await fetchTextData(decryptedUrl);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BulkResults(
                partsList: partsList,
              )),
    );
  }

  void openScannerScreen(String paramater) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScanPage()),
    );

    if (paramater == "bulk") {
      if (result != null) {
        formatCSVToList(result);
      }
    } else {
      if (result != null) {
        partModel.partNumber = result;
        searchPartNumber();
      }
    }
  }

  Future<void> getPartNumbers() async {
    http.Response response = await FormController.getTable("inventory");
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double desktopPadding = screenWidth * 0.22;
    final double mobilePadding = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: screenWidth < 800 ? mobilePadding : desktopPadding,
        ),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    // Part Number
                    flex: 3,
                    child: CustomTextField(
                      hintText: "Número de Parte",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      onChanged: (String value) {
                        updatePartNumber(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    // QR Button
                    flex: 1,
                    child: CustomIconButton(
                      text: screenWidth < 800 ? "" : "Escanea",
                      icon: Icons.qr_code,
                      height: 50,
                      width: screenWidth,
                      iconPadding: 12,
                      onPressed: () => openScannerScreen("query"),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    // Description TextField
                    flex: 3,
                    child: // Description
                        CustomTextField(
                      hintText: "Descripción",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      onChanged: (String value) {
                        updateDescription(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    // QR Button
                    flex: 1,
                    child: Container(),
                  )
                ],
              ),
              const SizedBox(height: 48),
              // Search Button

              CustomIconButton(
                text: "Actualizar",
                icon: Icons.refresh,
                height: 50,
                width: screenWidth,
                onPressed: asyncInit,
              ),
              const SizedBox(height: 48),

              SizedBox(
                height: screenHeight - 400,
                child: ListView.builder(
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
                            partnumber: parts[index]["partnumber"].toString(),
                            location: parts[index]["location"].toString(),
                            description: parts[index]["description"].toString(),
                            qty: parts[index]["quantity"].toString(),
                            partsList: parts[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC8ACD6),
        onPressed: () => openScannerScreen("bulk"),
        child: const Icon(
          Icons.add,
          color: Color(0xFF17153B),
        ),
      ),
    );
  }
}
