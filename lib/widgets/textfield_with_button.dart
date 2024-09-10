import 'dart:io';

import 'package:flutter/material.dart';

class TextFieldWithButton extends StatelessWidget {
  const TextFieldWithButton({
    super.key,
    required this.screenWidth,
    required this.partNumberController,
    required this.updatePartNumber,
    required this.openScannerScreen,
  });

  final double screenWidth;
  final TextEditingController partNumberController;
  final Function(String) updatePartNumber;
  final Function(String) openScannerScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth <= 800 ? screenWidth : screenWidth * 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      height: 50,
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
                          hintText: "Número de Parte",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                        controller: partNumberController,
                        onChanged: (String value) {
                          updatePartNumber(value);
                        },
                      ),
                    ),
                    Platform.isAndroid
                        ? IconButton(
                            icon: const Icon(
                              Icons.qr_code,
                              color: Colors.white,
                            ),
                            onPressed: () => openScannerScreen("query"),
                          )
                        : Container(),
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
