import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFConverter {
  static Future<void> generatePdf(List<List<dynamic>> table) async {
    final headers = [
      "Número de Parte",
      "Descripción",
      "Movimiento",
      "Cantidad",
      "Orden",
      "Usuario",
      "Fecha y Hora"
    ];

    final data = table;

    // create pdf document
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    doc.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.letter.copyWith(
            marginBottom: 0,
            marginLeft: 10,
            marginRight: 10,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.landscape,
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(
              top: 30,
              left: 10,
              right: 10,
              bottom: 30,
            ),
            child: pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: headers.map(
                    (header) {
                      return pw.Container(
                        color: PdfColors.blueGrey900,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          header.toString(),
                          style: pw.TextStyle(
                              fontSize: 14,
                              color: PdfColors.white,
                              fontWeight: pw.FontWeight.bold),
                        ),
                      );
                    },
                  ).toList(),
                ),
                ...data.map((row) {
                  return pw.TableRow(
                    children: row.map((cell) {
                      return pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(cell.toString()),
                      );
                    }).toList(),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );

    final timestamp = DateTime.now().microsecondsSinceEpoch;

    final directory = Platform.isWindows
        ? (await getDownloadsDirectory())!.path
        : Platform.isAndroid
            ? '/storage/emulated/0/Download'
            : (await getApplicationDocumentsDirectory()).path;

    final file = File("$directory/report$timestamp.pdf");
    await file.writeAsBytes(await doc.save());
  }
}
