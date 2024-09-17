import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/utils/ui.dart';
import 'package:qr_warehouse/widgets/custom_dropdown_button.dart';
import 'package:qr_warehouse/widgets/custom_form_text_field.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';

class CreatePartNumberPage extends StatefulWidget {
  const CreatePartNumberPage({super.key});

  @override
  State<CreatePartNumberPage> createState() => _CreatePartNumberPageState();
}

class _CreatePartNumberPageState extends State<CreatePartNumberPage> {
  // formkey to validate form
  final formKey = GlobalKey<FormState>();

  // String showed if the user doesn't select a measure unit and tries to add to inventory
  String? dropDownError;

  // currently selected measure unit
  String? selectedMeasure;

  // list of available measurement units
  List<String> measurements = ["EACH", "SET", "KIT", "IN", "FT", "YD"];

  // Focus Node
  final focusNode = FocusNode();

  // Text Controllers
  final partNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final manufacterController = TextEditingController();
  final mnfPartNumberController = TextEditingController();

  @override
  void dispose() {
    partNumberController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    locationController.dispose();
    manufacterController.dispose();
    mnfPartNumberController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // function that validated form before updating the database
  void validateForm() {
    bool isValid = formKey.currentState!.validate();

    if (selectedMeasure == "" || selectedMeasure == null) {
      setState(() {
        dropDownError = "Selecciona una medida";
        isValid = false;
      });
    }

    if (isValid) {
      addToInventory(context);
    } else {
      Ui.showSnackbar(context, "Error en el registro");
    }
  }

  // validates part number
  String? validatePartNumber(value) {
    // part number regex
    RegExp regex = RegExp(r'\d{2}-[A-Z0-9]{1}\d{1}-[A-Z0-9]{4}-\d{2}|(MISC)');
    String? match = regex.stringMatch(value);

    if (value == null || value.isEmpty || match == null) {
      return 'Ingresa un número de parte válido.';
    }
    return null;
  }

  // validates quantity
  String? validateQuantity(value) {
    if (value == null || value.isEmpty) {
      return 'Ingresa una cantidad.';
    }
    return null;
  }

  // updates database with new values
  addToInventory(context) async {
    String partNumber = partNumberController.text;
    String description = descriptionController.text;
    String quantity = quantityController.text;
    String min = "0";
    String max = "0";
    String location = locationController.text;
    String manufacter = manufacterController.text;
    String mnfPartNumber = mnfPartNumberController.text;
    bool isActive = true;

    String values =
        "'$partNumber', '$description', '$selectedMeasure', $quantity, $min, $max, '$location', '$manufacter', '$mnfPartNumber', $isActive";
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
    setState(() {
      selectedMeasure = null;
    });
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
                        onFieldSubmitted: (_) => validateForm(),
                      ),
                      const SizedBox(height: 16),

                      //QUANTITY AND MEASUREMENT UNIT
                      SizedBox(
                        width: 600,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity
                            CustomFormTextField(
                              width:
                                  screenWidth < 1200 ? 400 : screenWidth * 0.2,
                              controller: quantityController,
                              hintText: "Cantidad",
                              textInputType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^-?\d*\.?\d*')),
                              ],
                              validator: (value) => validateQuantity(value),
                              onFieldSubmitted: (_) => validateForm(),
                            ),

                            // MEASUUREMENT UNIT
                            Column(
                              children: [
                                CustomDropDownButton(
                                  menuItems: const [
                                    "EACH",
                                    "SET",
                                    "KIT",
                                    "IN",
                                    "FT",
                                    "YD"
                                  ],
                                  type: "Measures",
                                  hint: "Medida",
                                  selectedValue: selectedMeasure,
                                  icon: Icons.aspect_ratio_sharp,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedMeasure = value;
                                      dropDownError = null;
                                    });
                                  },
                                ),
                                dropDownError == null
                                    ? const SizedBox.shrink()
                                    : Text(
                                        dropDownError ?? "",
                                        style: const TextStyle(
                                          color: Color(0xFFAF8690),
                                        ),
                                      )
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Location
                      CustomFormTextField(
                        width: 600,
                        controller: locationController,
                        hintText: "Locación",
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        onFieldSubmitted: (_) => validateForm(),
                      ),
                      const SizedBox(height: 16),

                      // Manufacter
                      CustomFormTextField(
                        width: 600,
                        controller: manufacterController,
                        hintText: "Proveedor",
                        onFieldSubmitted: (_) => validateForm(),
                      ),
                      const SizedBox(height: 16),

                      // Manufacter Part Number
                      CustomFormTextField(
                        width: 600,
                        controller: mnfPartNumberController,
                        hintText: "Número de Parte del Proveedor",
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        onFieldSubmitted: (_) => validateForm(),
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
