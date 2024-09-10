import 'package:flutter/material.dart';

class InventoryDescriptionField extends StatelessWidget {
  const InventoryDescriptionField({
    super.key,
    required this.screenWidth,
    required this.descriptionController,
    required this.updateDescription,
  });

  final double screenWidth;
  final TextEditingController descriptionController;
  final Function(String) updateDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      height: 61,
      width: screenWidth <= 800 ? screenWidth : screenWidth * 0.5,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF17153B),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Descripción",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                        controller: descriptionController,
                        onChanged: (String value) {
                          updateDescription(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
