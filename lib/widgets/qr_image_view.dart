import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_warehouse/pages/qr_code_page.dart';

class QRImageView extends StatelessWidget {
  const QRImageView({
    super.key,
    required GlobalKey<State<StatefulWidget>> qrkey,
    required this.widget,
    required this.screenWidth,
  }) : _qrkey = qrkey;

  final GlobalKey<State<StatefulWidget>> _qrkey;
  final QRCodePage widget;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: RepaintBoundary(
        key: _qrkey,
        child: QrImageView(
          data: widget.code,
          version: QrVersions.auto,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          size: screenWidth * 0.3,
          gapless: true,
        ),
      ),
    );
  }
}
