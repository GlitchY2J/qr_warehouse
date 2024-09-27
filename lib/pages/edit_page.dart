import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late TextEditingController measureController;
  late TextEditingController quantityController;
  late TextEditingController minController;
  late TextEditingController maxController;
  late TextEditingController locationController;
  late TextEditingController manufacterController;
  late TextEditingController mnfPartNumberController;

  void getPartNumberInTextField() {
    partNumberController =
        TextEditingController(text: widget.partNumber.partNumber);
    descriptionController =
        TextEditingController(text: widget.partNumber.description);
    measureController = TextEditingController(text: widget.partNumber.measure);
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

  void disposeTextControllers() {
    partNumberController.dispose();
    descriptionController.dispose();
    measureController.dispose();
    quantityController.dispose();
    minController.dispose();
    maxController.dispose();
    locationController.dispose();
    manufacterController.dispose();
    mnfPartNumberController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPartNumberInTextField();
  }

  @override
  void dispose() {
    super.dispose();
    disposeTextControllers();
  }

  void showMessage(String message) {
    SnackBar snackBar;
    snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void returnToPreviousPage(PartNumber returnValue) {
    Navigator.pop(context, returnValue);
  }

  PartNumber createNewPartNumber(
    String partNumber,
    String description,
    String measure,
    String quantity,
    String min,
    String max,
    String location,
    String manufacter,
    String mnfPartNumber,
    String isActive,
  ) {
    PartNumber newPart = PartNumber(
      partNumber: partNumber,
      description: description,
      measure: measure,
      quantity: quantity,
      min: min,
      max: max,
      location: location,
      manufacter: manufacter,
      mnfPartNumber: mnfPartNumber,
      isActive: isActive,
    );

    return newPart;
  }

  updatePartNumber() async {
    // get values from the controllers
    String partNumber = partNumberController.text;
    String description = descriptionController.text;
    String measure = measureController.text;
    String quantity = quantityController.text;
    String min = minController.text;
    String max = maxController.text;
    String location = locationController.text;
    String manufacter = manufacterController.text;
    String mnfPartNumber = mnfPartNumberController.text;

    // Create String to store message
    String message = '';

    // create values and condition strings
    String values =
        "description = '$description', measure_unit = '$measure', min = $min, max = $max, location = '$location', manufacter = '$manufacter', mnfpartnumber = '$mnfPartNumber'";
    String condition = "partnumber = '$partNumber'";

    // Updating Record
    Map<String, dynamic> result =
        await FormController.updateRecord(values, condition);

    // If the update was made correctly then show a success message and go back to previous page
    if (result["success"] == "true") {
      message = "Actualización exitosa.";
      // Create a new Part Number to store all edited data
      PartNumber myPartNumber = createNewPartNumber(
          partNumber,
          description,
          measure,
          quantity,
          min,
          max,
          location,
          manufacter,
          mnfPartNumber,
          '1');
      // Return to previous page and get the new part number created with you
      returnToPreviousPage(myPartNumber);
    } else {
      message = "La actualización no pudo ser completada.";
    }
    // Showing message
    showMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 54, horizontal: 100),
          child: Center(
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      Container(
                        width: 600,
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Editando ${widget.partNumber.partNumber}...",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),

                      const SizedBox(height: 64),
                      // Part Number
                      // CustomTextField(
                      //   width: 600,
                      //   labelText: "Número de Parte",
                      //   controller: partNumberController,
                      //   enabled: false,
                      // ),
                      // const SizedBox(height: 16),

                      // Description
                      CustomTextField(
                        width: 600,
                        labelText: "Descripción",
                        controller: descriptionController,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      CustomTextField(
                        width: 600,
                        labelText: "Unidad de Medida",
                        controller: measureController,
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
                      const SizedBox(height: 64),

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
