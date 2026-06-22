import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'status_monitor_report_pdf_theme.dart';

class StatusMonitorReportPdfDocumentShell {
  const StatusMonitorReportPdfDocumentShell();

  Future<Uint8List> build({
    required String title,
    required List<pw.Widget> children,
    bool useCjkFont = false,
  }) async {
    final doc = pw.Document(
      title: title,
      author: 'SolgoInsight',
      creator: 'SolgoInsight',
    );
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.fromLTRB(36, 32, 36, 30),
          theme: await _theme(useCjkFont: useCjkFont),
          buildBackground: (_) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: StatusMonitorReportPdfTheme.sheet),
          ),
        ),
        build: (_) => children,
      ),
    );
    return doc.save();
  }

  Future<pw.ThemeData> _theme({required bool useCjkFont}) async {
    if (!useCjkFont) {
      return pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      );
    }
    try {
      return pw.ThemeData.withFont(
        base: await PdfGoogleFonts.notoSansSCRegular(),
        bold: await PdfGoogleFonts.notoSansSCBold(),
      );
    } catch (_) {
      return pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      );
    }
  }
}
