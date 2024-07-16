import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_warehouse/utils/form_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovementPage extends StatefulWidget {
  final Map<String, dynamic> parts;
  final int quantity;
  final String partnumber;
  final String action;
  final String title;

  const MovementPage(
      {super.key,
      required this.parts,
      required this.quantity,
      required this.partnumber,
      required this.action,
      required this.title});

  @override
  State<MovementPage> createState() => _MovementPageState();
}

class _MovementPageState extends State<MovementPage> {
  int qty = 0;
  final orderController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void initState() {
    qty = widget.quantity;
    super.initState();
  }

  @override
  void dispose() {
    orderController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  updateInventoryAndRecords(type) async {
    // get current user
    final pref = await SharedPreferences.getInstance();
    final user = pref.getString("username");

    // get and format datetime
    final DateTime now = DateTime.now();
    final dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    final String formattedDateTime = dateTimeFormatter.format(now);

    /// UPDATE

    /// Calculating updated quantity
    int quantity;
    if (widget.action == "substract") {
      quantity = qty - int.parse(quantityController.text);
      type = "Salida";
    } else {
      quantity = qty + int.parse(quantityController.text);
      type = "Entrada";
    }

    String values = "quantity = $quantity";

    /// Setting up condition
    String condition = "partnumber = '${widget.partnumber}'";

    /// Updating Record
    Map<String, dynamic> result =
        await FormController.updateRecord(values, condition);

    /// Creating snackbar
    SnackBar snackBar;

    /// If uptading inventory correctly then
    if (result["success"] == "true") {
      values =
          "'DEFAULT', '${widget.partnumber.toString()}', '$type', ${int.parse(quantityController.text)}, '$user', '$formattedDateTime', '${orderController.text}', null, null";
      result = await FormController.insertRecords("movements", values);

      // If updateding movements correctly
      if (result["success"] == "true") {
        snackBar = const SnackBar(content: Text("Registro Completo."));
        qty = quantity;
        if (context.mounted) {
          Navigator.pop(context, qty);
        }
      } else {
        snackBar = const SnackBar(
            content: Text("El registro no pudo ser completado."));
      }
    } else {
      snackBar =
          const SnackBar(content: Text("El registro no pudo ser completado."));
    }

    /// Showing message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = "";

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
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Part Number
                      SizedBox(
                        width: 600,
                        child: TextFormField(
                          controller: orderController,
                          decoration: const InputDecoration(
                            labelText: "Work Order/PO",
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
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
                      const SizedBox(height: 64),

                      // Add Part Number Button
                      SizedBox(
                        width: 600.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          onPressed: () async {
                            updateInventoryAndRecords(type);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("Confirmar"),
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
