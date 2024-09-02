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

class MovementGridView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Positioned(
      top: screenHeight * 0.28,
      left: screenWidth * 0.03,
      width: screenWidth * 0.94,
      bottom: 10,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth < 800 ? 1 : 2,
              childAspectRatio: screenWidth < 800 ? 6 : 8,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20),
          itemCount: movements.length < 20 ? movements.length : 20,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            return Stack(
              children: [
                /// CARD CONTAINER
                ContainerCard(
                  movements: movements,
                  index: index,
                ),

                /// PART NUMBER
                PartNumberCard(
                  movements: movements,
                  index: index,
                ),

                /// PART DESCRIPTION
                DescriptionCard(
                  movements: movements,
                  index: index,
                ),

                /// ARROW ICON
                ArrowIconCard(
                  movements: movements,
                  index: index,
                ),

                /// QUANTITY TEXT
                QuantityTextCard(
                  movements: movements,
                  index: index,
                ),

                /// ORDER NUMBER
                OrderNumberCard(
                  movements: movements,
                  index: index,
                ),

                /// USERNAME
                UsernameCard(
                  movements: movements,
                  index: index,
                ),

                /// Datetime
                DateTimeCard(
                  movements: movements,
                  index: index,
                ),
              ],
            );
          }),
    );
  }
}
