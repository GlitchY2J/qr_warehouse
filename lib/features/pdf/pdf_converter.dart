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

    //get division number
    const rowsPerTable = 17;
    var chunks = [];
    for (var i = 0; i < table.length; i += rowsPerTable) {
      chunks.add(table.sublist(i,
          i + rowsPerTable > table.length ? table.length : i + rowsPerTable));
    }

    print(chunks);

    // create pdf document
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    var data = table;

    doc.addPage(
      pw.MultiPage(
        maxPages: 100,
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
        build: (pw.Context context) => [
          pw.Padding(
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
                            fontSize: 10,
                            color: PdfColors.white,
                          ),
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
          ),
        ],
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
