import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
          child: Center(
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      // Part Number
                      SizedBox(
                        width: 600,
                        child: TextFormField(
                          controller: partNumberController,
                          decoration: const InputDecoration(
                            labelText: "Número de Parte",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: "Descripción",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quantity
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          controller: quantityController,
                          decoration: const InputDecoration(
                            labelText: "Cantidad",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Location
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(
                            labelText: "Locación",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Manufacter
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          controller: manufacterController,
                          decoration: const InputDecoration(
                            labelText: "Proveedor",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Manufacter Part Number
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          controller: mnfPartNumberController,
                          decoration: const InputDecoration(
                            labelText: "Número de Parte del Proveedor  ",
                          ),
                        ),
                      ),
                      const SizedBox(height: 124),

                      // Add Part Number Button
                      SizedBox(
                        width: 600.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          onPressed: () async {
                            Map<String, dynamic> result =
                                await FormController.processData(
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
                                  : const Text(
                                      "El registro no pudo ser completado."),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Añadir al Inventario'),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Add Part Number Button
                      SizedBox(
                        width: 600.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    QRCodePage(code: partNumberController.text),
                              ),
                            );
                          },
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Generar Codigo QR'),
                        ),
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
