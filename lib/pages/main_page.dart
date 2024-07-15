import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/pages/inventory_form.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/query_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';

import 'package:http/http.dart' as http;

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

  List allmovements = [];
  List movements = [];

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  void asyncInit() async {
    await getMovements();
  }

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

  void handleClick(int item) {
    switch (item) {
      case 0:
        navigator?.pushReplacement(
            CupertinoPageRoute(builder: (BuildContext context) => LoginPage()));
        break;
    }
  }

  Future<void> getMovements() async {
    http.Response response = await FormController.getTable("movements");
    setState(() {
      allmovements = jsonDecode(response.body);
      movements = allmovements;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth / 2) - 40;

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
        actions: [
          PopupMenuButton(
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Cerrar Sesión"),
              )
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            width: screenWidth,
            height: screenHeight * 0.7,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF17153B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 25,
            child: Row(
              children: [
                // Add Part Number Button
                CustomIconButton(
                  text: "Añadir Número de Parte",
                  icon: Icons.add,
                  height: 100,
                  width: buttonWidth,
                  onPressed: () => Get.to(() => const InventoryFormPage()),
                ),
                const SizedBox(width: 30),

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
          Positioned(
            top: screenHeight * 0.28,
            left: screenWidth * 0.05,
            width: screenWidth * 0.9,
            bottom: 10,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 6,
                  mainAxisSpacing: 20,
                ),
                itemCount: movements.length < 20 ? movements.length : 20,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                movements[index]["type"].toString() == "Entrada"
                                    ? const Color(0xFFA1C398)
                                    : const Color(0xFFFA7070),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 25,
                        child: Text(
                          movements[index]["partnumber"].toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 50,
                        left: 40,
                        child: Text(
                          "Part Number Description",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: screenWidth / 2,
                        child: movements[index]["type"].toString() == "Entrada"
                            ? const Icon(
                                Icons.arrow_circle_down,
                                size: 50,
                              )
                            : const Icon(
                                Icons.arrow_circle_up,
                                size: 50,
                              ),
                      ),
                      Positioned(
                        top: 25,
                        left: (screenWidth / 2) + 55,
                        child: Text(
                          movements[index]["quantity"].toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 28,
                        right: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "WO: 10750",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
