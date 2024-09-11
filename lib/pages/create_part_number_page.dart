import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_form_text_field.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/custom_textfield.dart';

class CreatePartNumberPage extends StatefulWidget {
  const CreatePartNumberPage({super.key});

  @override
  State<CreatePartNumberPage> createState() => _CreatePartNumberPageState();
}

class _CreatePartNumberPageState extends State<CreatePartNumberPage> {
  // formkey to validate form
  final formKey = GlobalKey<FormState>();

  // Focus Node
  final focusNode = FocusNode();
  // Text Controllers
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
    focusNode.dispose();
    super.dispose();
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      addToInventory(context);
    }
  }

  String? validatePartNumber(value) {
    // part number regex
    RegExp regex = RegExp(r'\d{2}-\d{2}-[A-Z0-9]{4}-\d{2}|(MISC)');
    String? match = regex.stringMatch(value);

    if (value == null || value.isEmpty || match == null) {
      return 'Ingresa un número de parte válido.';
    }
    return null;
  }

  String? validateQuantity(value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa una cantidad.';
    }
    return null;
  }

  addToInventory(context) async {
    String partNumber = partNumberController.text;
    String description = descriptionController.text;
    String measurementUnit = measurementUnitController.text;
    String quantity = quantityController.text;
    String min = "0";
    String max = "0";
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

  void clearForm() {
    partNumberController.clear();
    descriptionController.clear();
    quantityController.clear();
    locationController.clear();
    manufacterController.clear();
    mnfPartNumberController.clear();
    measurementUnitController.clear();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double desktopPadding = screenWidth * 0.33;
    final double mobilePadding = screenWidth * 0.10;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: screenWidth < 1200 ? mobilePadding : desktopPadding,
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Nuevo Número de Parte',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      // Part Number
                      CustomFormTextField(
                        width: 600,
                        focusNode: focusNode,
                        controller: partNumberController,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        hintText: "Número de Parte",
                        validator: (value) => validatePartNumber(value),
                        onFieldSubmitted: (_) => validateForm(),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      CustomFormTextField(
                        width: 600,
                        controller: descriptionController,
                        hintText: "Descripción",
                      ),
                      const SizedBox(height: 16),

                      // Quantity
                      CustomFormTextField(
                        width: 600,
                        controller: quantityController,
                        hintText: "Cantidad",
                        textInputType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^-?\d*\.?\d*')),
                        ],
                        validator: (value) => validateQuantity(value),
                        onFieldSubmitted: (_) => validateForm(),
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
                        onPressed: () => validateForm(),
                      ),
                      const SizedBox(height: 22),
                      CustomIconButton(
                        width: 600,
                        text: "Limpiar Formulario",
                        icon: Icons.cleaning_services,
                        height: 50,
                        onPressed: () => clearForm(),
                      ),
                      const SizedBox(height: 22),

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

// helper that format text to uppercase
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
