import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/details_page.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_container_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_description_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_location_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_measure_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_partnumber_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_quantity_card.dart';

class PartsGridView extends StatelessWidget {
  const PartsGridView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.parts,
    required this.onReturned,
  });

  final double screenHeight;
  final double screenWidth;
  final List<PartNumber> parts;
  final VoidCallback onReturned;

  @override
  Widget build(BuildContext context) {
    debugPrint("building gridview");
    return SizedBox(
      height: screenHeight - 400,
      width: screenWidth < 800 ? screenWidth : screenWidth * 0.4,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 6,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: parts.length < 30 ? parts.length : 30,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => DetailsPage(
                      partNumber: parts[index],
                    ),
                  ),
                )
                    .then((_) {
                  onReturned();
                });
              },
              child: Stack(
                children: [
                  // CONTAINER CARD
                  InventoryContainerCard(
                    parts: parts,
                    index: index,
                  ),

                  // PART NUMBER
                  InventoryPartNumberCard(
                    parts: parts,
                    index: index,
                  ),

                  InventoryDescriptionCard(
                    parts: parts,
                    index: index,
                  ),

                  // Location
                  InventoryLocationCard(
                    parts: parts,
                    index: index,
                  ),

                  InventoryQuantityCard(
                    parts: parts,
                    index: index,
                  ),

                  InventoryMeasureCard(
                    parts: parts,
                    index: index,
                  )
                ],
              ),
            );
          }),
      // child: ListView.builder(
      //   scrollDirection: Axis.vertical,
      //   shrinkWrap: true,
      //   itemCount: parts.length < 20 ? parts.length : 20,
      //   itemBuilder: (context, index) {
      //     if (parts[index].isActive == '1') {
      //       return Material(
      //         type: MaterialType.transparency,
      //         elevation: 1.0,
      //         color: Colors.transparent,
      //         shadowColor: Colors.grey[50],
      //         child: Container(
      //           padding: const EdgeInsets.symmetric(
      //             vertical: 10,
      //             horizontal: 20,
      //           ),
      //           child: InkWell(
      //             onTap: () {},
      //             child: CustomCard(
      //               partNumber: parts[index],
      //               getPartNumber: () => getPartNumbers,
      //             ),
      //           ),
      //         ),
      //       );
      //     } else {
      //       return Container();
      //     }
      //   },
      // ),
    );
  }
}
