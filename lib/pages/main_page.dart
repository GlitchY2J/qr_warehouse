import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/pages/inventory_form.dart';
import 'package:qr_warehouse/pages/query_page.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';

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
    final height = MediaQuery.of(context).size.height;
    final buttonWidth = (MediaQuery.of(context).size.width / 2) - 40;

    return Scaffold(
      backgroundColor: const Color(0xFF2E236E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E236E),
        leading: const Padding(
          padding: EdgeInsets.only(left: 15, top: 10),
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 32,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 10),
            child: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Add Part Number Button
                  CustomIconButton(
                    text: "Añadir Número de Parte",
                    icon: Icons.add,
                    height: 100,
                    width: buttonWidth,
                    onPressed: () => Get.to(() => const InventoryFormPage()),
                  ),

                  // Query button
                  CustomIconButton(
                    text: "Consultar",
                    icon: Icons.search,
                    height: 100,
                    width: buttonWidth,
                    onPressed: () => Get.to(() => const QueryPage()),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Positioned(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF17153B),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: height * 0.80,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text("asdf"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
