import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/custom_textfield.dart';

class CreatePartNumberPage extends StatefulWidget {
  const CreatePartNumberPage({super.key});

  @override
  State<CreatePartNumberPage> createState() => _CreatePartNumberPageState();
}

class _CreatePartNumberPageState extends State<CreatePartNumberPage> {
  final partNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final manufacterController = TextEditingController();
  final mnfPartNumberController = TextEditingController();
  final measurementUnitController = TextEditingController();

  @override
  void dispose() {
    partNumberController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    locationController.dispose();
    manufacterController.dispose();
    mnfPartNumberController.dispose();
    measurementUnitController.dispose();
    super.dispose();
  }

  addToInventory(context) async {
    String partNumber = partNumberController.text;
    String description = descriptionController.text;
    String measurementUnit = measurementUnitController.text;
    String quantity = quantityController.text;
    String min = "0";
    String max = "100";
    String location = locationController.text;
    String manufacter = manufacterController.text;
    String mnfPartNumber = mnfPartNumberController.text;
    bool isActive = true;

    String values =
        "'$partNumber', '$description', '$measurementUnit', $quantity, $min, $max, '$location', '$manufacter', '$mnfPartNumber', $isActive";
    Map<String, dynamic> result =
        await FormController.insertRecords("inventory", values);

    SnackBar snackBar = SnackBar(
      content: result["success"] == "true"
          ? const Text("Registro Completo.")
          : const Text("El registro no pudo ser completado."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  generateQRCode(context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (BuildContext context) =>
            QRCodePage(code: partNumberController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
          child: Center(
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      // Part Number
                      CustomTextField(
                        width: 600,
                        controller: partNumberController,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        hintText: "Número de Parte",
                      ),
                      const SizedBox(height: 16),

                      // Description
                      CustomTextField(
                        width: 600,
                        controller: descriptionController,
                        hintText: "Descripción",
                      ),
                      const SizedBox(height: 16),

                      // Quantity
                      CustomTextField(
                        width: 600,
                        controller: quantityController,
                        hintText: "Cantidad",
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^-?\d*\.?\d*')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Measurement Unit
                      CustomTextField(
                        width: 600,
                        controller: measurementUnitController,
                        hintText: "Unidad de Medida",
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Location
                      CustomTextField(
                        width: 600,
                        controller: locationController,
                        hintText: "Locación",
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Manufacter
                      CustomTextField(
                        width: 600,
                        controller: manufacterController,
                        hintText: "Proveedor",
                      ),
                      const SizedBox(height: 16),

                      // Manufacter Part Number
                      CustomTextField(
                        width: 600,
                        controller: mnfPartNumberController,
                        hintText: "Número de Parte del Proveedor",
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                      ),
                      const SizedBox(height: 100),

                      // Add Part Number Button
                      CustomIconButton(
                        width: 600,
                        text: "Añadir al Inventario",
                        icon: Icons.add,
                        height: 50,
                        onPressed: () => addToInventory(context),
                      ),
                      const SizedBox(height: 32),

                      // Generate QR Code
                      CustomIconButton(
                        text: "Generar Código QR",
                        icon: Icons.qr_code_scanner,
                        height: 50,
                        width: 600,
                        onPressed: () => generateQRCode(context),
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
    );
  }
}
