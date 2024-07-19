import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_warehouse/pages/inventory_form.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/movement_page.dart';
import 'package:qr_warehouse/pages/movement_report.dart';
import 'package:qr_warehouse/pages/query_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  void handleClick(int item) async {
    switch (item) {
      case 0:
        {
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.clear();
          navigator?.pushReplacement(
            CupertinoPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        }
        break;
    }
  }

  Future<void> getMovements() async {
    http.Response response = await FormController.getMovements();
    setState(() {
      allmovements = jsonDecode(response.body);
      movements = allmovements;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.3;

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
            left: 70,
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
                  onPressed: () => {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(
                      builder: (context) => const QueryPage(),
                    ))
                        .then((value) {
                      getMovements();
                    })
                  },
                ),
                const SizedBox(width: 30),

                // Print Report
                CustomIconButton(
                  text: "Imprimir Reporte",
                  icon: Icons.print,
                  height: 100,
                  width: buttonWidth,
                  onPressed: () => {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(
                      builder: (context) => MovementReport(
                        movementsList: movements,
                      ),
                    ))
                        .then((value) {
                      getMovements();
                    })
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.28,
            left: screenWidth * 0.03,
            width: screenWidth * 0.94,
            bottom: 10,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth < 800 ? 1 : 2,
                    childAspectRatio: screenWidth < 800 ? 6 : 8,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20),
                itemCount: movements.length < 20 ? movements.length : 20,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      /// CARD CONTAINER
                      CardContainer(
                        movements: movements,
                        index: index,
                      ),

                      /// PART NUMBER
                      CardPartNumber(
                        movements: movements,
                        index: index,
                      ),

                      /// PART DESCRIPTION
                      CardDescription(
                        movements: movements,
                        index: index,
                      ),

                      /// ARROW ICON
                      CardArrowIcon(
                        movements: movements,
                        index: index,
                      ),

                      /// QUANTITY TEXT
                      CardQuantityText(
                        movements: movements,
                        index: index,
                      ),

                      /// ORDER NUMBER
                      CardOrderNumber(
                        movements: movements,
                        index: index,
                      ),

                      /// USERNAME
                      CardUsername(
                        movements: movements,
                        index: index,
                      ),

                      /// Datetime
                      CardDatetime(
                        movements: movements,
                        index: index,
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

class CardDatetime extends StatelessWidget {
  const CardDatetime({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  String formatDate(date) {
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    String formatedDate = DateFormat("MM-dd-yyyy HH:mm").format(dateTime);
    return formatedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 30,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          formatDate(movements[index]["datetime"]),
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class CardUsername extends StatelessWidget {
  const CardUsername({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 30,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          movements[index]["username"].toString(),
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class CardOrderNumber extends StatelessWidget {
  const CardOrderNumber({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 30,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            movements[index]["order_number"].toString(),
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CardQuantityText extends StatelessWidget {
  const CardQuantityText({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 34,
      left: 380,
      child: Text(
        movements[index]["quantity"].toString(),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CardArrowIcon extends StatelessWidget {
  const CardArrowIcon({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 330,
      child: movements[index]["type"].toString() == "Entrada"
          ? const Icon(
              Icons.arrow_circle_down,
              size: 50,
            )
          : const Icon(
              Icons.arrow_circle_up,
              size: 50,
            ),
    );
  }
}

class CardDescription extends StatelessWidget {
  const CardDescription({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 65,
      left: 45,
      child: Text(
        movements[index]["description"].toString(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white54,
        ),
      ),
    );
  }
}

class CardPartNumber extends StatelessWidget {
  const CardPartNumber({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 22,
      left: 45,
      child: Text(
        movements[index]["partnumber"].toString(),
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.movements,
    required this.index,
  });

  final List<dynamic> movements;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: movements[index]["type"].toString() == "Entrada"
                ? const Color(0xFFA1C398)
                : const Color(0xFFFA7070),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
