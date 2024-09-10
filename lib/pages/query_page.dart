import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/bulk_results.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/qr_scan_page.dart';
import 'package:qr_warehouse/utils/encrypt_data.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/utils/ui.dart';
import 'package:qr_warehouse/widgets/confirm_excel_file_to_load.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/inventory_description_field.dart';
import 'package:qr_warehouse/widgets/parts_cant_be_updated.dart';
import 'package:qr_warehouse/widgets/parts_gridview.dart';
import 'package:qr_warehouse/widgets/textfield_with_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // List of bulk parts
  List<dynamic> bulkList = [];
  // List of not updated parts
  List<dynamic> notUpdated = [];

  // filters
  String filterPartNumber = '';
  String filterDescription = '';

  // text controllers
  final partNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
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

  void bulkUpdate(List<dynamic> partList) async {
    List<dynamic> updated = [];

    for (dynamic part in partList) {
      String statement = part[4];
      String condition = part[5];

      /// Updating Record
      Map<String, dynamic> result =
          await FormController.updateRecord(statement, condition);

      // if rows affected is > 0 then part exists and was update
      // otherwise part doesn't exist or can't be updated
      if (result["rows"] > 0) {
        updated.add(part);
      } else {
        notUpdated.add(part);
      }
    }
    // end of loop

    // get current user
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString("username");

    // get and format datetime
    final DateTime now = DateTime.now();
    final dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    final String formattedDateTime = dateTimeFormatter.format(now);

    for (dynamic part in updated) {
      String partNumber = part[0];
      String quantity = part[1];
      String po = part[2];
      String so = part[3];
      // Insert updated into movements
      String values =
          "'DEFAULT', '$partNumber', 'Entrada', ${double.parse(quantity)}, '$user', '$formattedDateTime', null, '$so', '$po'";

      // Insert record into Movements table
      FormController.insertRecords("movements", values);
    }
  }

  Future<void> dialogBuilder(
      BuildContext context, List<dynamic> list, Widget widget) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return widget;
        });
  }

  Future<List<dynamic>> loadFromExcel() async {
    List<dynamic> data = [];

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["xlsx", "xlsm"],
      type: FileType.custom,
      allowMultiple: false,
    );

    if (result != null) {
      String file = result.paths.single!;
      Uint8List bytes = await File(file).readAsBytes();
      Excel excel = Excel.decodeBytes(bytes);

      // variable to check if the sheet accounting data exists
      bool notValidExcel = true;

      // gets all sheets
      for (var table in excel.tables.keys) {
        // if sheet is name "Accounting Data"
        if (table == "Accounting Data") {
          // checks all rows
          for (var row in excel.tables[table]!.rows) {
            if (row[0] != null) {
              // if row is 14 or higher
              if (row[0]!.rowIndex > 12) {
                // store values in a list

                // [0] part number
                // [1] quantity
                // [2] PO
                // [3] SO
                // [4] statement
                // [5] conditions
                data.add([
                  row[0]!.value.toString(),
                  row[1]!.value.toString(),
                  row[3]!.value.toString(),
                  row[4]!.value.toString(),
                  "quantity = quantity + ${row[1]!.value.toString()}",
                  "partnumber = '${row[0]!.value.toString()}';"
                ]);
              }
            }
          }
          notValidExcel = false;
        }
      }

      if (notValidExcel) {
        if (mounted) {
          Ui.showSnackbar(context, "Archivo de Excel no válido.");
        }
        return [];
      }

      return data;

      //updateRecords(bulkList);
    } else {
      debugPrint("file not selected");
      return [];
    }
  }

  updateRecords(List<dynamic> bulkList) async {
    for (int i = 0; i < bulkList.length; i++) {
      // get current user
      final pref = await SharedPreferences.getInstance();
      final user = pref.getString("username");

      // get and format datetime
      final DateTime now = DateTime.now();
      final dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

      final String date = dateTimeFormatter.format(now);

      // extracting values from list
      String id = "DEFAULT";
      String partNumber = bulkList[i][0];
      int quantity = int.parse(bulkList[i][1]);
      String type = 'Entrada';
      String order = bulkList[i][2];
      String statement = bulkList[i][3];
      String condition = bulkList[i][4];

      // try updating value
      Map<String, dynamic> result =
          await FormController.updateRecord(statement, condition);

      // add to movements table
      if (result["rows"] > 0) {
        String values =
            "'$id', '$partNumber', '$type', $quantity, '$user', '$date', '$order', null, null";

        // Insert record into Movements table
        result = await FormController.insertRecords("movements", values);

        // Creating snackbar
        SnackBar snackBar;

        // If updating movements correctly
        if (result["success"] == "true") {
          print("Se añadio $quantity al numero de parte $partNumber");
          snackBar = const SnackBar(content: Text("Registro Completo."));
        } else {
          snackBar = const SnackBar(
              content: Text("El registro no pudo ser completado."));
        }

        /// Showing message
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
      } else {
        print("part number: $partNumber no existe en la bade de datos");
      }
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
    debugPrint(value.toString());
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double mobilePadding = screenWidth * 0.06;
    final double desktopPaddingMd = screenWidth * 0.1;
    final double desktopPaddinglg = screenWidth * 0.01;
    final double desktopPaddingxl = screenWidth * 0.3;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: screenWidth <= 800
              ? mobilePadding
              : screenWidth >= 800 && screenWidth <= 1200
                  ? desktopPaddingMd
                  : screenWidth >= 1200 && screenWidth <= 1600
                      ? desktopPaddinglg
                      : desktopPaddingxl,
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
                width: screenWidth < 800 ? screenWidth : screenWidth * 0.5,
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
      floatingActionButton: Platform.isWindows
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFC8ACD6),
              onPressed: () async => {
                // load data from excel
                bulkList = await loadFromExcel(),

                // if the excel file is a valid one
                if (bulkList.isNotEmpty)
                  {
                    // show data from excel table and update database
                    await dialogBuilder(
                      context,
                      bulkList,
                      ConfirmExcelFileToLoad(
                        list: bulkList,
                        bulkUpdate: bulkUpdate,
                      ),
                    ),

                    // show data not updated
                    notUpdated.isNotEmpty
                        ? dialogBuilder(
                            context,
                            notUpdated,
                            PartsCantBeUpdated(list: notUpdated),
                          )
                        : null
                  }
              },
              child: const Icon(
                Icons.add,
                color: Color(0xFF17153B),
              ),
            )
          : Container(),
    );
  }
}
