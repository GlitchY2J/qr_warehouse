import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPage extends StatelessWidget {
  final Map<String, dynamic> parts;

  const EditPage({
    super.key,
    required this.parts,
  });

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
                          decoration: const InputDecoration(
                            labelText: "Número de Parte",
                          ),
                          initialValue: parts["0"],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Descripción",
                          ),
                          initialValue: parts["1"],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quantity
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Cantidad",
                          ),
                          initialValue: parts["2"],
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
                          decoration: const InputDecoration(
                            labelText: "Locación",
                          ),
                          initialValue: parts["3"],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Manufacter
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Proveedor",
                          ),
                          initialValue: parts["4"],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Manufacter Part Number
                      SizedBox(
                        width: 600.0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Número de Parte del Proveedor",
                          ),
                          initialValue: parts["4"],
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
                          onPressed: () {},
                          icon: const Icon(Icons.check),
                          label: const Text("Atualizar"),
                        ),
                      ),
                      const SizedBox(height: 32),
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
