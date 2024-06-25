import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/movement_page.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> parts;

  const DetailsPage({
    super.key,
    required this.parts,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late int quantity;

  @override
  void initState() {
    quantity = int.parse(widget.parts["2"]);
    super.initState();
  }

  _goToMovementPage(BuildContext context, String action) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MovementPage(
          parts: widget.parts,
          quantity: quantity,
          partnumber: widget.parts["0"],
          action: action,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        quantity = result;
      });
    }
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
                      SizedBox(width: 600, child: Text(widget.parts["0"])),
                      const SizedBox(height: 16),
                      SizedBox(width: 600, child: Text(widget.parts["1"])),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                  width: 200, child: Text(widget.parts["3"]))),
                          Container(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                                width: 50, child: Text(quantity.toString())),
                          ),
                        ],
                      ),
                      const SizedBox(height: 64),
                      SizedBox(
                        width: 600.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          onPressed: () {
                            _goToMovementPage(context, "substract");
                          },
                          icon: const Icon(Icons.move_down),
                          label: const Text("Surtir Orden"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 600.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )),
                          onPressed: () {
                            _goToMovementPage(context, "add");
                          },
                          icon: const Icon(Icons.move_up),
                          label: const Text("Añadir a Inventario"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
