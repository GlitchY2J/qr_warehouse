import 'package:flutter/material.dart';
import 'package:qr_warehouse/models/movement.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/arrow_icon_card.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/container_card.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/datetime_card.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/description_card.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/order_number_card.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/partnumber_card.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/quantity_text_card.dart';
import 'package:qr_warehouse/widgets/movement_card_widgets/username_card.dart';

class MovementGridView extends StatefulWidget {
  const MovementGridView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.movements,
  });

  final double screenHeight;
  final double screenWidth;
  final List<Movement> movements;

  @override
  State<MovementGridView> createState() => _MovementGridViewState();
}

class _MovementGridViewState extends State<MovementGridView> {
  // number of cards incremented when scrolled down
  int incrementItems = 10;

  // default number of displayed items
  int displayedItems = 20;

  // scroll controller
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // scroll listener, load more items when scrolled down
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreItems();
      }
    });
  }

  // increment items to displayed items
  void loadMoreItems() {
    setState(() {
      displayedItems += incrementItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = widget.screenWidth;

    return Positioned(
      top: widget.screenHeight * 0.28,
      left: screenWidth * 0.03,
      width: screenWidth * 0.94,
      bottom: 10,
      child: GridView.builder(
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth <= 1200 ? 1 : 2,
            childAspectRatio: screenWidth <= 800
                ? 6
                : screenWidth >= 800 && screenWidth <= 1200
                    ? 7
                    : screenWidth >= 1200 && screenWidth <= 1600
                        ? 5
                        : 7,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: widget.movements.length < displayedItems
              ? widget.movements.length
              : displayedItems,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return Stack(
              children: [
                /// CARD CONTAINER
                ContainerCard(
                  movements: widget.movements,
                  index: index,
                ),

                /// PART NUMBER
                PartNumberCard(
                  movements: widget.movements,
                  index: index,
                ),

                /// PART DESCRIPTION
                DescriptionCard(
                  movements: widget.movements,
                  index: index,
                ),

                /// ARROW ICON
                ArrowIconCard(
                  movements: widget.movements,
                  index: index,
                ),

                /// QUANTITY TEXT
                QuantityTextCard(
                  movements: widget.movements,
                  index: index,
                ),

                /// ORDER NUMBER
                OrderNumberCard(
                  movements: widget.movements,
                  index: index,
                ),

                /// USERNAME
                UsernameCard(
                  movements: widget.movements,
                  index: index,
                ),

                /// Datetime
                DateTimeCard(
                  movements: widget.movements,
                  index: index,
                ),
              ],
            );
          }),
    );
  }
}
