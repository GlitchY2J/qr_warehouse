import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_warehouse/models/movement.dart';
import 'package:qr_warehouse/models/user.dart';
import 'package:qr_warehouse/pages/login_page.dart';
import 'package:qr_warehouse/pages/movement_report.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:http/http.dart' as http;
import 'package:qr_warehouse/widgets/custom_positioned_button.dart';
import 'package:qr_warehouse/widgets/custom_drawer.dart';
import 'package:qr_warehouse/widgets/custom_dropdown_button.dart';
import 'package:qr_warehouse/widgets/custom_floating_action_button.dart';
import 'package:qr_warehouse/widgets/movement_gridview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    this.user,
    this.prefs,
  });

  // Username and SharePreferences
  final User? user;
  final SharedPreferences? prefs;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // List to store movements from database
  List<Movement> allMovements = [];

  // List to store filtered moves
  List<Movement> filteredMovements = [];

  // List of filters for dropdownmenu
  List<String> menuFilters = [
    'Por Número de Parte',
    'Por Usuario',
    'Por Movimiento',
    'Por Número de Orden'
  ];

  // List of filters
  Map<String, List<String>> filters = {
    'partNumber': [],
    'username': [],
    'orderNumber': [],
    'type': [],
  };

  // unique values for filters
  List<String> uniquePartNumbers = [];
  List<String> uniqueUsers = [];
  List<String> uniqueOrders = [];
  List<String> uniqueTypes = [];

  // dates
  DateFormat dateFormat = DateFormat('MM-dd-yyyy');
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    debugPrint("init state");
    startDate = DateTime(2023, 1, 1);
    endDate = DateTime.now();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      asyncInit();
    });
  }

  void asyncInit() async {
    debugPrint("async init");
    await getMovements();
    filteredMovements = allMovements;
    updateUniqueValues();
    //initializeFilters();
  }

  void selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          //startDate = '';
        } else {
          //endDate = '';
        }
        applyFiltersAndUpdate();
      });
    }
  }

  // applies filters
  List<Movement> applyFilters(
      List<Movement> movements, Map<String, List<String>> filters) {
    List<Movement> filteredMovements = movements;

    filters.forEach((filter, value) {
      if (value.isNotEmpty) {
        filteredMovements = filteredMovements.where((move) {
          if (filter == 'partNumber') return value.contains(move.partNumber);
          if (filter == 'username') return value.contains(move.username);
          if (filter == 'orderNumber') return value.contains(move.orderNumber);
          if (filter == 'type') return value.contains(move.type);
          return true;
        }).toList();
      }
    });

    filteredMovements = filteredMovements.where((move) {
      DateTime dateTime = DateTime.parse(move.dateTime);
      return dateTime.isAfter(startDate) && dateTime.isBefore(endDate);
    }).toList();

    return filteredMovements;
  }

  // restart filters
  void restartFilters() {
    setState(() {
      initializeFilters();
      filteredMovements = allMovements;
    });
  }

  void initializeFilters() {
    setState(() {
      // Makes all checkboxes start unchecked
      filters['partNumber'] = [];
      filters['username'] = [];
      filters['orderNumber'] = [];
      filters['type'] = [];
      startDate = DateTime(2023, 1, 1);
      endDate = DateTime.now();
    });
  }

  void goToMovementReport() {
    Navigator.of(context)
        .push(CupertinoPageRoute(
      builder: (context) => MovementReport(
        movementsList: filteredMovements,
      ),
    ))
        .then((value) {
      getMovements();
    });
  }

  // updates unique values
  void updateUniqueValues() {
    setState(() {
      uniquePartNumbers =
          allMovements.map((move) => move.partNumber).toSet().toList();
      uniqueUsers = allMovements.map((move) => move.username).toSet().toList();
      uniqueOrders =
          allMovements.map((move) => move.orderNumber).toSet().toList();
      uniqueTypes = allMovements.map((move) => move.type).toSet().toList();
    });
  }

  // apply filters and update
  void applyFiltersAndUpdate() {
    setState(() {
      filteredMovements = applyFilters(allMovements, filters);
      updateUniqueValues();
    });
  }

  // toggles filters
  void toggleFilter(String category, String value) {
    setState(() {
      if (filters[category]!.contains(value)) {
        filters[category]!.remove(value);
      } else {
        filters[category]!.add(value);
      }
      //applyFiltersAndUpdate();
    });
  }

  // check if filter is valid
  bool isValidFilter(String category, String value) {
    final tempFilters = Map<String, List<String>>.from(filters);
    tempFilters[category] = [value];
    return applyFilters(allMovements, tempFilters).isNotEmpty;
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
    debugPrint("getting movements");
    http.Response response = await FormController.getMovements();
    if (response.statusCode == 200) {
      setState(() {
        allMovements = List<Movement>.from(
          jsonDecode(response.body).map((model) => Movement.fromJson(model)),
        );
      });
    }
  }

  // triggers on checkbox change
  Function(bool?)? onCheckboxChange([String? field, String? value]) {
    return isValidFilter(field!, value!)
        ? (checked) {
            {
              setState(() {
                toggleFilter(field, value);
              });
            }
          }
        : null;
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      startDate = args.value.startDate;
      endDate = args.value.endDate ?? args.value.startDate;

      // End date needs to be at 23:59:59
      endDate =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 0, 0);
    }
  }

  Future<void> dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF17153B),
          title: const Text('Seleccionar Rango de Fecha'),
          content: SizedBox(
            width: 500,
            height: 500,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: SfDateRangePicker(
                monthFormat: "MMMM",
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Color(0xFF17153B),
                ),
                todayHighlightColor: const Color(0xFFC8ACD6),
                rangeTextStyle: const TextStyle(color: Colors.white),
                selectionColor: const Color(0xFFC8ACD6),
                rangeSelectionColor: const Color(0xFF2E236E),
                backgroundColor: const Color(0xFF17153B),
                onSelectionChanged: onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: startDate == DateTime(2023, 1, 1)
                    ? PickerDateRange(DateTime.now(), DateTime.now())
                    : PickerDateRange(startDate, endDate),
                // initialSelectedRange: PickerDateRange(
                //   DateTime.now(),
                //   DateTime.now(),
                // ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Aplicar'),
              onPressed: () {
                setState(() {
                  applyFiltersAndUpdate();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("building widget");
    // user related variables
    final String? userType = widget.user?.userType;
    final String? savedUserType = widget.prefs?.getString("userType");

    // resolution variables
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2E236E),
      drawer: CustomDrawer(
        widget: widget,
        userType: userType,
        savedUserType: savedUserType,
        refreshMovements: asyncInit,
      ),
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
          // Dropwdown Button Filters
          CustomDropDownButton(
            top: 50,
            left: 60,
            menuFilters: menuFilters,
            height: screenHeight,
            filters: filters,
            isValidFilter: isValidFilter,
            toggleFilter: toggleFilter,
            applyFiltersAndUpdate: applyFiltersAndUpdate,
            uniques: {
              'partNumber': uniquePartNumbers,
              'username': uniqueUsers,
              'orderNumber': uniqueOrders,
              'type': uniqueTypes,
            },
          ),

          CustomPositionedButton(
            top: 100,
            left: 40,
            width: screenWidth < 800 ? 250 : 300,
            text: "Reiniciar Filtros",
            onTap: () {
              restartFilters();
            },
          ),

          CustomPositionedButton(
            top: 100,
            left: screenWidth < 800 ? 300 : 350,
            width: screenWidth < 800 ? 250 : 300,
            text: "Rangos de Fecha",
            onTap: () => dialogBuilder(context),
          ),

          /// Darker background
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

          /// Movements grid view
          MovementGridView(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            movements: filteredMovements,
          ),
        ],
      ),

      /// Go to table view
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => goToMovementReport(),
        icon: const Icon(
          Icons.table_chart,
          color: Color(0xFF17153B),
        ),
      ),
    );
  }
}
