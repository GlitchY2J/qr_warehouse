import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovementPage extends StatefulWidget {
  final PartNumber partNumber;
  final String action;
  final String title;

  const MovementPage(
      {super.key,
      required this.partNumber,
      required this.action,
      required this.title});

  @override
  State<MovementPage> createState() => _MovementPageState();
}

class _MovementPageState extends State<MovementPage> {
  final formKey = GlobalKey<FormState>();
  int qty = 0;
  final orderController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void initState() {
    qty = int.parse(widget.partNumber.quantity);
    super.initState();
  }

  @override
  void dispose() {
    orderController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  updateInventoryAndRecords(type) async {
    // get current user
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString("username");

    // get and format datetime
    final DateTime now = DateTime.now();
    final dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    final String formattedDateTime = dateTimeFormatter.format(now);

    /// UPDATE

    /// Calculating updated quantity
    int quantity;
    if (widget.action == "substract") {
      quantity = qty - int.parse(quantityController.text);
      type = "Salida";
    } else {
      quantity = qty + int.parse(quantityController.text);
      type = "Entrada";
    }

    String values = "quantity = $quantity";

    /// Setting up condition
    String condition = "partnumber = '${widget.partNumber.partNumber}'";

    /// Updating Record
    Map<String, dynamic> result =
        await FormController.updateRecord(values, condition);

    /// Creating snackbar
    SnackBar snackBar;

    /// If uptading inventory correctly then
    if (result["success"] == "true") {
      values =
          "'DEFAULT', '${widget.partNumber.partNumber}', '$type', ${int.parse(quantityController.text)}, '$user', '$formattedDateTime', '${orderController.text}', null, null";
      result = await FormController.insertRecords("movements", values);

      // If updateding movements correctly
      if (result["success"] == "true") {
        snackBar = const SnackBar(content: Text("Registro Completo."));
        qty = quantity;
        if (context.mounted) {
          Navigator.pop(context, qty);
        }
      } else {
        snackBar = const SnackBar(
            content: Text("El registro no pudo ser completado."));
      }
    } else {
      snackBar =
          const SnackBar(content: Text("El registro no pudo ser completado."));
    }

    /// Showing message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool validateWorkOrder = false;
    bool validateQuantity = false;

    final screenWidth = MediaQuery.of(context).size.width;
    final double desktopPadding = screenWidth * 0.33;
    final double mobilePadding = screenWidth * 0.10;
    String type = "";

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
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // CustomTextField(
                    //   controller: orderController,
                    //   hintText: "Work Order/PO",
                    // ),

                    TextFormField(
                      controller: orderController,
                      decoration: InputDecoration(
                        hintText: 'Work Order',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade400),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un Work Order';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    TextFormField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        hintText: 'Cantidad',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue.shade400),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.parse(value) < 1) {
                          return 'Ingresa una cantidad válida';
                        }
                        return null;
                      },
                    ),

                    // CustomTextField(
                    //   controller: quantityController,
                    //   hintText: "Cantidad",
                    //   keyboardType: TextInputType.number,
                    //   inputFormatters: <TextInputFormatter>[
                    //     FilteringTextInputFormatter.digitsOnly
                    //   ],
                    // ),

                    const SizedBox(height: 64),

                    // Add Part Number Button

                    CustomIconButton(
                      text: "Confirmar",
                      icon: Icons.check,
                      height: 50,
                      width: double.infinity,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          updateInventoryAndRecords(type);
                        }
                      },
                    ),

                    const SizedBox(height: 32),
                    // Add Part Number Button
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
