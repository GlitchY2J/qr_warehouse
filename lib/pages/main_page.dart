import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/pages/inventory_form.dart';
import 'package:qr_warehouse/pages/query_page.dart';
// import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 64),
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      // Add Part Number Button
                      SizedBox(
                        width: 600.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          onPressed: () =>
                              Get.to(() => const InventoryFormPage()),
                          icon: const Icon(Icons.add),
                          label: const Text('Añadir Número de Parte'),
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
                          onPressed: () => Get.to(() => const QueryPage()),
                          icon: const Icon(Icons.search),
                          label: const Text('Consultar'),
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
