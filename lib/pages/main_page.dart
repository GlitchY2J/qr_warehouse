import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_warehouse/models/movement.dart';
import 'package:qr_warehouse/models/user.dart';
import 'package:qr_warehouse/pages/inventory_form.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/movement_report.dart';
import 'package:qr_warehouse/pages/query_page.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:qr_warehouse/widgets/astrophysics_logo.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/widgets/custom_button.dart';
import 'package:qr_warehouse/widgets/movement_gridview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filter_list/filter_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    this.user,
    this.prefs,
  });

  final User? user;
  final SharedPreferences? prefs;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List to store movements from database
  List<Movement> allMovements = [];

  // List to store filtered moves
  List<Movement> selectedMovementList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
  }

  void asyncInit() async {
    await getMovements();
  }

  // shows a dialog for filters
  void movementFilters(String property) async {
    await FilterListDialog.display<Movement>(
      context,
      themeData: FilterListThemeData.raw(
        // Choice Chip theme
        choiceChipTheme: const ChoiceChipThemeData(
          backgroundColor: Color(0xFF433D8B),
          selectedBackgroundColor: Color(0xFFC8ACD6),
          side: BorderSide.none,
        ),

        // Header Theme
        headerTheme: const HeaderThemeData(
          backgroundColor: Color(0xFF17153B),
          searchFieldBackgroundColor: Color(0xFF433D8B),
          closeIconColor: Colors.white,
          searchFieldIconColor: Colors.white,
          searchFieldHintText: "Buscar...",
        ),

        // Control Button Bar Theme
        controlBarButtonTheme: ControlButtonBarThemeData(context,
            backgroundColor: const Color(0xFF433D8B),
            controlButtonTheme: const ControlButtonThemeData(
              primaryButtonBackgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              textStyle: TextStyle(
                color: Colors.white,
              ),
            )),

        borderRadius: 10,
        wrapAlignment: WrapAlignment.start,
        wrapCrossAxisAlignment: WrapCrossAlignment.start,
        wrapSpacing: 10,
        backgroundColor: const Color(0xFF17153B),
      ),
      applyButtonText: "Aplicar",
      resetButtonText: "Reiniciar",
      allButtonText: "Todos",
      selectedItemsText: "selecionados",
      width: 800,
      height: 1000,
      listData: selectedMovementList,
      selectedListData: selectedMovementList,
      choiceChipLabel: (move) => property == "Por Número de Parte"
          ? move!.partNumber
          : property == "Por Usuario"
              ? move!.username
              : property == "Por Movimiento"
                  ? move!.type
                  : property == "Por Orden"
                      ? move!.orderNumber
                      : property == "Por Fecha"
                          ? move!.dateTime
                          : null,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (move, query) {
        if (property == "Por Número de Parte") {
          return move.partNumber.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Usuario") {
          return move.username.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Movimiento") {
          return move.type.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Orden") {
          return move.orderNumber.toLowerCase().contains(query.toLowerCase());
        } else if (property == "Por Fecha") {
          return move.dateTime.toLowerCase().contains(query.toLowerCase());
        } else {
          return false;
        }
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedMovementList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  // handle events of 3 points menu
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

  // function that get movements table from server
  Future<void> getMovements() async {
    http.Response response = await FormController.getMovements();
    if (response.statusCode == 200) {
      setState(() {
        allMovements = List<Movement>.from(
            jsonDecode(response.body).map((model) => Movement.fromJson(model)));
        //movements = allMovements;
        selectedMovementList = allMovements;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? selectedFilters;
    final List<String> filters = [
      "Por Número de Parte",
      "Por Usuario",
      "Por Movimiento",
      "Por Orden",
      "Por Fecha",
    ];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: Drawer(
        width: 320,
        backgroundColor: const Color(0xFF17153B),
        child: ListView(
          children: [
            Stack(
              children: [
                const Positioned(
                  top: 40,
                  left: 30,
                  child: AstrophysicsLogo(color: Colors.white, width: 250),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  child: Container(
                    width: 500,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFF17153B),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, top: 15),
                      child: RichText(
                        text: TextSpan(
                          text: "Bienvenido, ",
                          style: const TextStyle(fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                              text: widget.user?.fullName == null
                                  ? widget.prefs?.getString("fullName")
                                  : widget.user!.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC8ACD6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 160,
                ),
              ],
            ),
            widget.user?.userType == "Admin" ||
                    widget.prefs?.getString("userType") == "Admin"
                ? ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text("Añadir Número de Parte"),
                    onTap: () => {
                      Navigator.pop(context),
                      Navigator.of(context)
                          .push(CupertinoPageRoute(
                        builder: (context) => const InventoryFormPage(),
                      ))
                          .then((value) {
                        getMovements();
                      })
                    },
                  )
                : Container(),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text("Inventario"),
              onTap: () => {
                Navigator.pop(context),
                Navigator.of(context)
                    .push(CupertinoPageRoute(
                  builder: (context) => const QueryPage(),
                ))
                    .then((value) {
                  getMovements();
                })
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF2E236E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E236E),
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
            top: 10,
            left: 55,
            child: SizedBox(
              width: 250,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: const Expanded(
                    child: Text(
                      "Filtrar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  items: filters
                      .map((String filter) => DropdownMenuItem<String>(
                            value: filter,
                            child: Text(
                              filter,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  value: selectedFilters,
                  onChanged: (value) {
                    movementFilters(value!);
                    setState(() {
                      selectedFilters = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    width: 160,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF433D8B),
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFF433D8B),
                    ),
                    offset: const Offset(100, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: MaterialStateProperty.all(6),
                      thumbVisibility: MaterialStateProperty.all(true),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 60,
            left: -20,
            child: SizedBox(
              width: 400,
              child: CustomButton(
                  onTap: () {
                    setState(() {
                      selectedMovementList = allMovements;
                    });
                  },
                  text: "Reiniciar Filtros"),
            ),
          ),

          /// DARKER BACKGROUND
          Positioned(
            bottom: 0,
            width: screenWidth,
            height: screenHeight * 0.7,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF17153B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),

          /// MOVEMENT GRID
          MovementGridView(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            movements: selectedMovementList,
          ),
        ],
      ),

      /// TABLE VIEW
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC8ACD6),
        onPressed: () => {
          Navigator.of(context)
              .push(CupertinoPageRoute(
            builder: (context) => MovementReport(
              movementsList: selectedMovementList,
            ),
          ))
              .then((value) {
            getMovements();
          })
        },
        child: const Icon(
          Icons.table_chart,
          color: Color(0xFF17153B),
        ),
      ),
    );
  }
}
