import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/movement_page.dart';
import 'package:qr_warehouse/widgets/app_text.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';

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

  _goToMovementPage(BuildContext context, String action, String title) async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MovementPage(
          parts: widget.parts,
          quantity: quantity,
          partnumber: widget.parts["0"],
          action: action,
          title: title,
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
    final screenWidth = MediaQuery.of(context).size.width;

    final double desktopPadding = screenWidth * 0.22;
    final double mobilePadding = screenWidth * 0.06;

    final String partNumber = widget.parts["0"];
    final String description = widget.parts["1"];
    final String location = widget.parts["5"];

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: screenWidth < 800 ? mobilePadding : desktopPadding,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                // Part Number
                Container(
                  alignment: Alignment.topLeft,
                  child:
                      AppText(text: partNumber, color: Colors.white, size: 38),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.topLeft,
                  child: AppText(
                      text: description, color: Colors.white60, size: 18),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.topLeft,
                  child:
                      AppText(text: location, color: Colors.white60, size: 18),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.topLeft,
                  child: AppText(
                      text: quantity.toString(),
                      color: Colors.white60,
                      size: 18),
                ),
                const SizedBox(height: 64),
                CustomIconButton(
                  text: "Surtir Orden",
                  icon: Icons.move_down,
                  height: 50,
                  width: screenWidth,
                  onPressed: () =>
                      _goToMovementPage(context, "substract", "Surtir Orden"),
                ),
                const SizedBox(height: 20),
                CustomIconButton(
                  text: "Añadir a Inventario",
                  icon: Icons.move_up,
                  height: 50,
                  width: screenWidth,
                  onPressed: () =>
                      _goToMovementPage(context, "add", "Añadir a Inventario"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
