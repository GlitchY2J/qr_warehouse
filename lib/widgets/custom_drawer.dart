import 'package:flutter/material.dart';
import 'package:qr_warehouse/pages/main_page.dart';
import 'package:qr_warehouse/widgets/add_new_user_tile.dart';
import 'package:qr_warehouse/widgets/add_part_number_tile..dart';
import 'package:qr_warehouse/widgets/astro_logo.dart';
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
                left: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AstroLogo(width: 40),
                    SizedBox(width: 10),
                    Text(
                      'QR WAREHOUSE',
                      style: TextStyle(
                        fontFamily: 'Staatliches',
                        fontSize: 35,
                        color: Color(0xFFB174E7),
                      ),
                    ),
                  ],
                ),
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
          InventoryTile(refreshMovements: refreshMovements),
          userType == "Admin" || savedUserType == "Admin"
              ? AddPartNumberTile(getMovements: refreshMovements)
              : Container(),
          userType == "Admin" || savedUserType == "Admin"
              ? AddNewUserTile(getMovements: refreshMovements)
              : Container(),
        ],
      ),
    );
  }
}
