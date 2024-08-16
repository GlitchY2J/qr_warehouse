import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/bulk_results.dart';
import 'package:qr_warehouse/pages/qr_scan_page.dart';
import 'package:qr_warehouse/utils/encrypt_data.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/inventory_description_field.dart';
import 'package:qr_warehouse/widgets/parts_gridview.dart';
import 'package:qr_warehouse/widgets/textfield_with_button.dart';

class QueryPage extends StatefulWidget {
  const QueryPage({super.key});

  @override
  State<QueryPage> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  // variable to check if data is loading from database
  bool isLoading = true;

  // variable to store the partnumber being scanned
  String? scannedData;

  // Lists to store parts and filtered parts
  List<PartNumber> allParts = [];
  List<PartNumber> parts = [];

  // filters
  String filterPartNumber = '';
  String filterDescription = '';

  // text controllers
  final partNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    debugPrint("init state");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
  }

  void asyncInit() async {
    debugPrint("async init");
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

  void goToBulkResults(List<List<dynamic>> partsList) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BulkResults(
                partsList: partsList,
              )),
    );
  }

  formatCSVToList(String url) async {
    String decryptedUrl = decryptUrl(url);
    //String decryptedUrl = decryptUrl(url);
    List<List<dynamic>> partsList = await fetchTextData(decryptedUrl);

    goToBulkResults(partsList);
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
        filterPartNumber = result;
        searchPartNumber();
      }
    }
  }

  Future<void> getPartNumbers() async {
    debugPrint("getting part numbers");

    // clear textfields
    updatePartNumber('');
    updateDescription('');

    // clear controllers
    partNumberController.clear();
    descriptionController.clear();

    String conditions = "WHERE isActive = 1";

    http.Response response =
        await FormController.getTable("inventory", conditions);
    if (response.statusCode == 200) {
      setState(() {
        allParts = List<PartNumber>.from(jsonDecode(response.body)
            .map((model) => PartNumber.fromJson(model)));
        parts = allParts;
        isLoading = false;
      });
    }
  }

  void print(value) {
    debugPrint(value);
  }

  void updatePartNumber(String text) {
    filterPartNumber = text;
    searchPartNumber();
  }

  void updateDescription(String text) {
    filterDescription = text;
    searchPartNumber();
  }

  void searchPartNumber() {
    final suggestions = allParts.where((part) {
      final partNumber = part.partNumber.toLowerCase();
      final description = part.description.toLowerCase();

      return (partNumber.contains(filterPartNumber.toLowerCase()) &&
              description.contains(filterDescription.toLowerCase())) ||
          (description.contains(filterDescription.toLowerCase()) &&
              partNumber.contains(filterPartNumber.toLowerCase()));
    }).toList();

    setState(
      () => parts = suggestions,
    );
  }

  Future<void> refresh() {
    getPartNumbers();

    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("building widget");
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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: screenWidth < 800 ? mobilePadding : desktopPadding,
          ),
          child: Center(
            child: Column(
              children: [
                TextFieldWithButton(
                  screenWidth: screenWidth,
                  partNumberController: partNumberController,
                  updatePartNumber: updatePartNumber,
                  openScannerScreen: openScannerScreen,
                ),

                InventoryDescriptionField(
                  screenWidth: screenWidth,
                  descriptionController: descriptionController,
                  updateDescription: updateDescription,
                ),
                const SizedBox(height: 48),
                // Search Button

                CustomIconButton(
                  text: "Actualizar",
                  icon: Icons.refresh,
                  height: 50,
                  width: screenWidth < 800 ? screenWidth : screenWidth * 0.3,
                  onPressed: asyncInit,
                ),
                const SizedBox(height: 48),

                !isLoading
                    ? PartsGridView(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        parts: parts,
                        onReturned: getPartNumbers,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: screenWidth < 800
      //     ? FloatingActionButton(
      //         backgroundColor: const Color(0xFFC8ACD6),
      //         onPressed: () => openScannerScreen("bulk"),
      //         child: const Icon(
      //           Icons.add,
      //           color: Color(0xFF17153B),
      //         ),
      //       )
      //     : Container(),
    );
  }
}
