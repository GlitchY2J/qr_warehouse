import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/main_page.dart';
import 'package:qr_warehouse/widgets/add_part_number_tile..dart';
import 'package:qr_warehouse/widgets/astrophysics_logo.dart';
import 'package:qr_warehouse/widgets/inventory_tile.dart';
import 'package:qr_warehouse/widgets/welcome_text.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.widget,
    required this.userType,
    required this.savedUserType,
    required this.refreshMovements,
  });

  final MainPage widget;
  final String? userType;
  final String? savedUserType;
  final VoidCallback refreshMovements;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                child: WelcomeText(widget: widget),
              ),
              Container(
                height: 160,
              ),
            ],
          ),
          userType == "Admin" || savedUserType == "Admin"
              ? AddPartNumberTile(getMovements: refreshMovements)
              : Container(),
          InventoryTile(refreshMovements: refreshMovements),
        ],
      ),
    );
  }
}
