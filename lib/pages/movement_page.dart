// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/utils/formatters.dart';
import 'package:qr_warehouse/utils/ui.dart';
import 'package:qr_warehouse/widgets/confirm_widget.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MovementPage extends StatefulWidget {
  // final variables for PartNumber object, action (Sum or Sub) and title(Add to Inventory or Add to Work Order)
  final PartNumber partNumber;
  final String action;
  final String title;

  const MovementPage({
    super.key,
    required this.partNumber,
    required this.action,
    required this.title,
  });

  @override
  State<MovementPage> createState() => _MovementPageState();
}

class _MovementPageState extends State<MovementPage> {
  // formKey to validate form
  final formKey = GlobalKey<FormState>();

  // initial quantity
  final orderController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    orderController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  ///
  /// VERIFY MODIFICATIONS BEFORE UPDATING IN DATABASE
  ///
  Future<void> verifyPersistency(String part, String value) async {
    http.Response response = await FormController.getQuantity(part);

    if (response.statusCode == 200) {
      List<dynamic> quantities = jsonDecode(response.body);

      if (quantities[0]['quantity'] == value ||
          Formatters.numberToDouble(quantities[0]['quantity']) == value) {
        updateInventoryAndRecords();
      } else {
        // Values have been changed
        // Shows Confirmation Widget
        PartNumber newPartNumber = PartNumber(
          partNumber: widget.partNumber.partNumber,
          description: widget.partNumber.description,
          measure: widget.partNumber.measure,
          quantity: Formatters.integerOrDouble(
              quantities[0]['quantity'], widget.partNumber.measure),
          min: widget.partNumber.min,
          max: widget.partNumber.max,
          location: widget.partNumber.location,
          manufacter: widget.partNumber.manufacter,
          mnfPartNumber: widget.partNumber.mnfPartNumber,
          isActive: widget.partNumber.isActive,
        );
        Ui.showWidgetAlert(
          context,
          ConfirmWidget(
            partNumber: newPartNumber,
            addedQty: Formatters.integerOrDouble(
                quantityController.text, newPartNumber.measure),
            newQty: Formatters.integerOrDouble(
              calculateFinalQuantity(
                widget.action,
                num.parse(newPartNumber.quantity),
              ).toString(),
              newPartNumber.measure,
            ),
          ),
          () => updateInventoryAndRecords(),
          "confirmation",
        );
      }
    }
  }

  ///
  /// CALCULATE FINAL QUANTITY
  ///
  num calculateFinalQuantity(String action, num initialQuantity) {
    final num finalQuantity;
    if (action == "substract") {
      finalQuantity = initialQuantity - num.parse(quantityController.text);
    } else {
      finalQuantity = initialQuantity + num.parse(quantityController.text);
    }

    return finalQuantity;
  }

  ///
  /// UPDATE INVENTORY AND RECORDS
  ///
  void updateInventoryAndRecords() async {
    // create a reference for passed variables
    num initialQuantity = num.parse(Formatters.integerOrDouble(
        widget.partNumber.quantity, widget.partNumber.measure));

    String action = widget.action;

    // get current user
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString("username");

    // get and format datetime
    final DateTime now = DateTime.now();
    final dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    final String formattedDateTime = dateTimeFormatter.format(now);

    /// UPDATE

    /// Calculating updated quantity
    num finalQuantity = calculateFinalQuantity(action, initialQuantity);

    // Determines type of movement
    final String type = action == "substract" ? "Salida" : "Entrada";

    // values that are going to be updated in query
    String values = "quantity = $finalQuantity";

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
          "'DEFAULT', '${widget.partNumber.partNumber}', '$type', ${double.parse(quantityController.text)}, '$user', '$formattedDateTime', '${orderController.text}', null, null";

      // Insert record into Movements table
      result = await FormController.insertRecords("movements", values);

      // If updateding movements correctly
      if (result["success"] == "true") {
        snackBar = const SnackBar(content: Text("Registro Completo."));

        if (context.mounted) {
          PartNumber myPartNumber = PartNumber(
            partNumber: widget.partNumber.partNumber,
            description: widget.partNumber.description,
            measure: widget.partNumber.measure,
            quantity: finalQuantity.toString(),
            min: widget.partNumber.min,
            max: widget.partNumber.max,
            location: widget.partNumber.location,
            manufacter: widget.partNumber.manufacter,
            mnfPartNumber: widget.partNumber.mnfPartNumber,
            isActive: widget.partNumber.isActive,
          );
          Navigator.pop(context, myPartNumber);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final double desktopPadding = screenWidth * 0.33;
    final double mobilePadding = screenWidth * 0.10;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,

      // App Bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),

      // Sets body padding
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: screenWidth < 800 ? mobilePadding : desktopPadding,
        ),
        child: Center(
          child: Column(
            children: [
              // Form
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Title
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 50),

                    // work order Textfield
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

                    // quantity text field
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
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
                            num.parse(value) <= 0) {
                          return 'Ingresa una cantidad válida';
                        }
                        return null;
                      },
                    ),

                    //Separator
                    const SizedBox(height: 64),

                    // Add Part Number Button
                    CustomIconButton(
                      text: "Confirmar",
                      icon: Icons.check,
                      height: 50,
                      width: double.infinity,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Shows Confirmation Widget
                          Ui.showWidgetAlert(
                            context,
                            ConfirmWidget(
                              partNumber: widget.partNumber,
                              // addedQty: quantityController.text,
                              addedQty: Formatters.integerOrDouble(
                                  quantityController.text,
                                  widget.partNumber.measure),
                              newQty: Formatters.integerOrDouble(
                                  calculateFinalQuantity(widget.action,
                                          num.parse(widget.partNumber.quantity))
                                      .toString(),
                                  widget.partNumber.measure),
                            ),
                            // () => updateInventoryAndRecords(),
                            () => verifyPersistency(
                              widget.partNumber.partNumber.toString(),
                              widget.partNumber.quantity.toString(),
                            ),
                            widget.action,
                          );
                        }
                      },
                    ),
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
