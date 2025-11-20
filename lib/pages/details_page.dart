import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/edit_page.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/movement_page.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/app_text.dart';
import 'package:qr_warehouse/widgets/custom_button.dart';
import 'package:qr_warehouse/widgets/custom_floating_action_button.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailsPage extends StatefulWidget {
  final PartNumber partNumber;

  const DetailsPage({
    super.key,
    required this.partNumber,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String userType = '';
  late PartNumber myPartNumber;
  late String partNumber;
  late String description;
  late String location;
  late String quantity;

  bool isImageLoaded = false;
  String imagePath = '';
  bool imageExists = false;

  @override
  void initState() {
    getSharedPrefs();
    myPartNumber = widget.partNumber;
    setDetailsValues();
    loadImage();
    super.initState();
  }

  // GET TYPE OF USER
  dynamic getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString("userType")!;
    });
  }

  // PARSE NUMBER TO DOUBLE
  String numberToDouble(String value) {
    return double.parse(value).toStringAsFixed(1);
  }

  // PARSE NUMBER TO INTEGER
  String numberToInteger(String value) {
    return int.parse(value).toString();
  }

  // LOAD IMAGE
  Future<void> loadImage() async {
    // image server path
    final defaultImagePath =
        'http://10.30.0.41/Dashboard/qr_warehouse/images/$partNumber.png?timestamp=${DateTime.now().microsecondsSinceEpoch}';

    try {
      final response = await http.get(Uri.parse(defaultImagePath));
      if (response.statusCode == 200) {
        setState(() {
          // image path assigned and image loaded
          imagePath = defaultImagePath;
          isImageLoaded = true;
          imageExists = true;
        });
      } else {
        loadPlaceholderImage();
      }
    } catch (e) {
      loadPlaceholderImage();
    }
  }

  void loadPlaceholderImage() {
    setState(() {
      imagePath = 'assets/images/placeholder.jpg';
      isImageLoaded = true;
    });
  }

  // PICK IMAGE
  Future<void> pickImage() async {
    // Open file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      File selectedFile = File(filePath);

      if (imageExists == true) {
        bool? shouldReplace = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF17153B),
              title: const Text("Reemplazar Imagen"),
              content: const Text('¿Deseas reemplazar la imagen existente?'),
              actions: [
                CustomButton(
                  padding: EdgeInsets.zero,
                  text: 'Cancelar',
                  color: Colors.white,
                  textColor: Colors.black,
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  width: 200,
                ),
                CustomButton(
                  padding: EdgeInsets.zero,
                  text: 'Confirmar',
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  width: 200,
                )
              ],
            );
          },
        );

        if (shouldReplace ?? false) {
          await uploadImage(selectedFile);
        }
      } else {
        try {
          uploadImage(selectedFile);
          loadImage();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }
  }

  Future<void> uploadImage(File file) async {
    const uploadScript =
        'http://10.30.0.42/Dashboard/qr_warehouse/upload_files.php';

    var request = http.MultipartRequest('POST', Uri.parse(uploadScript));
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['customFileName'] = '${widget.partNumber.partNumber}.png';

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          imagePath =
              'http://10.30.0.42/Dashboard/qr_warehouse/images/$partNumber.png?timestamp=${DateTime.now().microsecondsSinceEpoch}';
        });
        debugPrint("success");
      } else {
        debugPrint("failure");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // SET DETAILS VALUES
  setDetailsValues() {
    partNumber = myPartNumber.partNumber;
    description = myPartNumber.description;
    location = myPartNumber.location;
    quantity = myPartNumber.measure == "FT" ||
            myPartNumber.measure == "IN" ||
            myPartNumber.measure == "YD"
        ? numberToDouble(myPartNumber.quantity)
        : numberToInteger(myPartNumber.quantity);
  }

  // GO TO MOVEMENT PAGE
  _goToMovementPage(BuildContext context, String action, String title) async {
    await Navigator.push(
      context,
      // Navigates to Movement Page
      CupertinoPageRoute(
        builder: (context) => MovementPage(
          partNumber: myPartNumber,
          action: action,
          title: title,
        ),
      ),

      // If a movement was made then update UI
    ).then((value) {
      if (value != null) {
        setState(() {
          myPartNumber = value;
        });
      }
      setDetailsValues();
    });
  }

  // DISABLE PART NUMBER
  disablePartNumber(String partNumber) async {
    String values = "isActive = 0";
    String condition = "partnumber = '$partNumber'";

    // Updating Record
    Map<String, dynamic> result =
        await FormController.updateRecord(values, condition);

    if (result["success"] == "true") {
    } else {}
  }

  // GENERATE QR CODE
  void goToQRCodePage() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => QRCodePage(
          code: partNumber,
        ),
      ),
    );
  }

  // WIDGET BUILD
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double desktopPadding = screenWidth * 0.32;
    final double mobilePadding = screenWidth * 0.06;

    return Scaffold(
      // background Color
      backgroundColor: const Color(0xFF17153B),
      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      // APP BAR
      // FLOATING ACTION BUTTON
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => goToQRCodePage(),
        icon: const Icon(
          Icons.qr_code,
          color: Color(0xFF17153B),
        ),
      ),
      // FLOATING ACTION BUTTON

      // BODY
      body: SingleChildScrollView(
        // padding
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: screenWidth < 800 ? mobilePadding : desktopPadding,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Part Number
                        Container(
                          alignment: Alignment.topLeft,
                          child: AppText(
                              text: partNumber, color: Colors.white, size: 38),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Container(
                          alignment: Alignment.topLeft,
                          child: AppText(
                              text: description,
                              color: Colors.white60,
                              size: 18),
                        ),
                        const SizedBox(height: 16),

                        // Location
                        Container(
                          alignment: Alignment.topLeft,
                          child: AppText(
                            text: 'Locación: $location',
                            color: Colors.white60,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Quantitty
                        Container(
                          alignment: Alignment.topLeft,
                          child: AppText(
                            text: 'Cantidad en Inventario: $quantity',
                            color: Colors.white60,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            isImageLoaded
                                ? Image.network(
                                    imagePath,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.jpg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : const CircularProgressIndicator(),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  pickImage();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.more_vert_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 64),

                // Button to add parts to order
                CustomIconButton(
                  text: "Salida de Inventario",
                  icon: Icons.move_down,
                  height: 50,
                  width: screenWidth,
                  onPressed: () => _goToMovementPage(
                      context, "substract", "Salida de $partNumber"),
                ),
                const SizedBox(height: 20),

                // Button to add parts to inventory
                CustomIconButton(
                  text: "Entrada de Inventario",
                  icon: Icons.move_up,
                  height: 50,
                  width: screenWidth,
                  onPressed: () => _goToMovementPage(
                      context, "add", "Entrada de $partNumber"),
                ),
                const SizedBox(height: 20),

                userType == "Admin"
                    ? Column(
                        children: [
                          // Button to edit part number
                          CustomIconButton(
                            text: "Editar Número de Parte",
                            icon: Icons.edit,
                            height: 50,
                            width: screenWidth,
                            onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => EditPage(
                                  // partNumber: widget.partNumber,
                                  partNumber: myPartNumber,
                                ),
                              ),
                            ).then((value) {
                              if (value != null) {
                                setState(() {
                                  myPartNumber = value;
                                });
                              }
                              setDetailsValues();
                            }),
                          ),
                          const SizedBox(height: 20),
                          // Button to delete part number (disable it)
                          CustomIconButton(
                            text: "Eliminar Número de Parte",
                            icon: Icons.delete,
                            height: 50,
                            width: screenWidth,
                            backgroundColor: const Color(0xFFFA7070),
                            onPressed: () => disablePartNumber(partNumber),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
