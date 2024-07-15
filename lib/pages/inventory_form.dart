import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/custom_textfield.dart';

class InventoryFormPage extends StatefulWidget {
  const InventoryFormPage({super.key});

  @override
  State<InventoryFormPage> createState() => _InventoryFormPageState();
}

class _InventoryFormPageState extends State<InventoryFormPage> {
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
    super.dispose();
  }

  addToInventory(context) async {
    Map<String, dynamic> result = await FormController.processData(
      partNumberController.text,
      descriptionController.text,
      quantityController.text,
      locationController.text,
      manufacterController.text,
      mnfPartNumberController.text,
    );

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
    final screenWidth = MediaQuery.of(context).size.width;
    final double desktopPadding = screenWidth * 0.25;
    final double mobilePadding = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: screenWidth < 600 ? mobilePadding : desktopPadding,
        ),
        child: Center(
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    const SizedBox(height: 150),
                    // Part Number
                    CustomTextField(
                      controller: partNumberController,
                      hintText: "Número de Parte",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Descripción",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    CustomTextField(
                      controller: quantityController,
                      hintText: "Cantidad",
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Location
                    CustomTextField(
                      controller: locationController,
                      hintText: "Locación",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    // Manufacter
                    CustomTextField(
                      controller: manufacterController,
                      hintText: "Proveedor",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    // Manufacter Part Number
                    CustomTextField(
                      controller: mnfPartNumberController,
                      hintText: "Número de Parte del Proveedor",
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 100),

                    // Add Part Number Button
                    CustomIconButton(
                      text: "Añadir al Inventario",
                      icon: Icons.add,
                      height: 50,
                      width: double.infinity,
                      onPressed: () => addToInventory(context),
                    ),
                    const SizedBox(height: 32),

                    // Generate QR Code
                    CustomIconButton(
                      text: "Generar Código QR",
                      icon: Icons.qr_code_scanner,
                      height: 50,
                      width: double.infinity,
                      onPressed: () => generateQRCode(context),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
