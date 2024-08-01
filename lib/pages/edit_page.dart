import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/custom_textfield.dart';

class EditPage extends StatefulWidget {
  final PartNumber partNumber;

  const EditPage({
    super.key,
    required this.partNumber,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController partNumberController;
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  late TextEditingController minController;
  late TextEditingController maxController;
  late TextEditingController locationController;
  late TextEditingController manufacterController;
  late TextEditingController mnfPartNumberController;

  @override
  void initState() {
    super.initState();
    partNumberController =
        TextEditingController(text: widget.partNumber.partNumber);
    descriptionController =
        TextEditingController(text: widget.partNumber.description);
    quantityController =
        TextEditingController(text: widget.partNumber.quantity);
    minController = TextEditingController(text: widget.partNumber.min);
    maxController = TextEditingController(text: widget.partNumber.max);
    locationController =
        TextEditingController(text: widget.partNumber.location);
    manufacterController =
        TextEditingController(text: widget.partNumber.manufacter);
    mnfPartNumberController =
        TextEditingController(text: widget.partNumber.mnfPartNumber);
  }

  @override
  void dispose() {
    super.dispose();
    partNumberController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    minController.dispose();
    maxController.dispose();
    locationController.dispose();
    manufacterController.dispose();
    mnfPartNumberController.dispose();
  }

  updatePartNumber() async {
    // get values from the controllers
    String partNumber = partNumberController.text;
    String description = descriptionController.text;
    String quantity = quantityController.text;
    String min = minController.text;
    String max = maxController.text;
    String location = locationController.text;
    String manufacter = manufacterController.text;
    String mnfPartNumber = mnfPartNumberController.text;

    // create values and condition strings
    String values =
        "description = '$description', quantity = $quantity, min = $min, max = $max, location = '$location', manufacter = '$manufacter', mnfpartnumber = '$mnfPartNumber', isActive = 1";
    String condition = "partnumber = '$partNumber'";

    /// Updating Record
    Map<String, dynamic> result =
        await FormController.updateRecord(values, condition);

    /// Creating snackbar
    SnackBar snackBar;

    if (result["success"] == "true") {
      snackBar = const SnackBar(content: Text("Actualización exitosa."));
      navigator?.pop();
    } else {
      snackBar = const SnackBar(
          content: Text("La actualización no pudo ser completada."));
    }

    /// Showing message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
        title: const Text("Editar número de parte"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 54, horizontal: 80),
          child: Center(
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      // Part Number
                      CustomTextField(
                        width: 600,
                        labelText: "Número de Parte",
                        controller: partNumberController,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      CustomTextField(
                        width: 600,
                        labelText: "Descripción",
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 16),

                      // Quantity
                      CustomTextField(
                        width: 600,
                        labelText: "Cantidad",
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Minimum inventory quantity
                      CustomTextField(
                        width: 600,
                        labelText: "Cantidad Mínima",
                        controller: minController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Maximum inventory quantity
                      CustomTextField(
                        width: 600,
                        labelText: "Cantidad Máxima",
                        controller: maxController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Location
                      CustomTextField(
                        width: 600,
                        labelText: "Locación",
                        controller: locationController,
                      ),
                      const SizedBox(height: 16),

                      // Manufacter
                      CustomTextField(
                        width: 600,
                        labelText: "Proveedor",
                        controller: manufacterController,
                      ),
                      const SizedBox(height: 16),

                      // Manufacter Part Number
                      CustomTextField(
                        width: 600,
                        labelText: "Número de Parte del Proveedor",
                        controller: mnfPartNumberController,
                      ),
                      const SizedBox(height: 24),

                      // Add Part Number Button
                      CustomIconButton(
                        text: "Actualizar",
                        icon: Icons.check,
                        height: 50,
                        width: 600,
                        onPressed: updatePartNumber,
                      ),

                      // Add Part Number Button
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
