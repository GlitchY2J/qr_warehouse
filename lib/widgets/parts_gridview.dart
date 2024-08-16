import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_warehouse/models/part_number.dart';
import 'package:qr_warehouse/pages/details_page.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_container_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_description_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_location_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_measure_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_partnumber_card.dart';
import 'package:qr_warehouse/widgets/inventory_card_widgets/inventory_quantity_card.dart';

class PartsGridView extends StatefulWidget {
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
  State<PartsGridView> createState() => _PartsGridViewState();
}

class _PartsGridViewState extends State<PartsGridView> {
  List<PartNumber> displayedParts = [];
  int incrementItems = 20;
  int displayedItems = 30;
  final ScrollController scrollController = ScrollController();

  void loadMoreItems() {
    debugPrint('load more items');
    setState(() {
      displayedItems += incrementItems;
    });
  }

  @override
  void initState() {
    super.initState();
    //incrementItems = widget.parts.length;
    //loadMoreItems();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreItems();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("building gridview");
    return SizedBox(
      height: widget.screenHeight - 400,
      width: widget.screenWidth < 800
          ? widget.screenWidth
          : widget.screenWidth * 0.4,
      child: GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 6,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: widget.parts.length < displayedItems
              ? widget.parts.length
              : displayedItems,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            String partnumber = widget.parts[index].partNumber;
            return GestureDetector(
              onLongPress: () {
                debugPrint('shows picture');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.asset(
                          'assets/images/parts/$partnumber.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              onTap: () {
                Navigator.of(context)
                    .push(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => DetailsPage(
                      partNumber: widget.parts[index],
                    ),
                  ),
                )
                    .then((_) {
                  widget.onReturned();
                });
              },
              child: Stack(
                children: [
                  // CONTAINER CARD
                  InventoryContainerCard(
                    parts: widget.parts,
                    index: index,
                  ),

                  // PART NUMBER
                  InventoryPartNumberCard(
                    parts: widget.parts,
                    index: index,
                  ),

                  InventoryDescriptionCard(
                    parts: widget.parts,
                    index: index,
                  ),

                  // Location
                  InventoryLocationCard(
                    parts: widget.parts,
                    index: index,
                  ),

                  InventoryQuantityCard(
                    parts: widget.parts,
                    index: index,
                  ),

                  InventoryMeasureCard(
                    parts: widget.parts,
                    index: index,
                  )
                ],
              ),
            );
          }),
    );
  }
}
