import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_warehouse/pages/main_page.dart';
import 'package:qr_warehouse/widgets/custom_icon_button.dart';
import 'package:qr_warehouse/widgets/qr_image_view.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key, required this.code});

  final String code;

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final GlobalKey _qrkey = GlobalKey();

  Future<void> convertQRCodeToImage(context) async {
    RenderRepaintBoundary boundary =
        _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    final directory = Platform.isWindows
        ? (await getDownloadsDirectory())!.path
        : Platform.isAndroid
            ? '/storage/emulated/0/Download'
            : (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = File("$directory/qrCode.png");

    await imgFile.writeAsBytes(pngBytes);

    SnackBar snackBar = const SnackBar(
        content: Text("Código QR guardado en la carpeta de Descargas."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double desktopPadding = screenWidth * 0.25;
    final double mobilePadding = screenWidth * 0.1;

    return Scaffold(
      backgroundColor: const Color(0xFF17153B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17153B),
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const MainPage()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 600 ? mobilePadding : desktopPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QRImageView(
                qrkey: _qrkey,
                widget: widget,
                screenWidth: screenWidth,
              ),
              const SizedBox(height: 50),

              // Export png button
              CustomIconButton(
                text: "Exportar",
                icon: Icons.save,
                height: 50,
                width: screenWidth * 0.3,
                onPressed: () => convertQRCodeToImage(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
