import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/edit_page.dart';
import 'package:qr_warehouse/pages/movement_page.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/app_text.dart';
import 'package:qr_warehouse/widgets/custom_floating_action_button.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    getSharedPrefs();
    myPartNumber = widget.partNumber;
    setDetailsValues();
    super.initState();
  }

  dynamic getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString("userType")!;
    });
  }

  String integerOrDouble(String value) {
    if (num.parse(value) % 1 == 0) {
      return int.parse(value).toString();
    } else {
      return double.parse(value).toStringAsFixed(1);
    }
  }

  setDetailsValues() {
    partNumber = myPartNumber.partNumber;
    description = myPartNumber.description;
    location = myPartNumber.location;

    quantity = integerOrDouble(myPartNumber.quantity);
  }

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

  disablePartNumber(String partNumber) async {
    String values = "isActive = 0";
    String condition = "partnumber = '$partNumber'";

    // Updating Record
    Map<String, dynamic> result =
        await FormController.updateRecord(values, condition);

    if (result["success"] == "true") {
    } else {}
  }

  void goToQRCodePage() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => QRCodePage(
          code: partNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double desktopPadding = screenWidth * 0.32;
    final double mobilePadding = screenWidth * 0.06;

    return Scaffold(
      // background Color
      backgroundColor: const Color(0xFF17153B),
      // App bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => goToQRCodePage(),
        icon: const Icon(
          Icons.qr_code,
          color: Color(0xFF17153B),
        ),
      ),

      // body
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
                        Image.network(
                          'http://10.30.0.42/Dashboard/qr_warehouse/images/$partNumber.png',
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
                    ?

                    // Button to delete part number (disable it)
                    Column(
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
                                  partNumber: widget.partNumber,
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
