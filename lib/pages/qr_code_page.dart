// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_warehouse/pages/main_page.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key, required this.code});

  final String code;

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final GlobalKey _qrkey = GlobalKey();

  Future<void> convertQRCodeToImage() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const MainPage()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: RepaintBoundary(
                key: _qrkey,
                child: QrImageView(
                  data: widget.code,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                  size: 350,
                  gapless: true,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 380.0,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
                onPressed: convertQRCodeToImage,
                icon: const Icon(Icons.save),
                label: const Text('Exportar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
