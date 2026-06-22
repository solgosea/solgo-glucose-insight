import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../doctor_glucose_report_pdf_theme.dart';
import '../../../models/report_view_model.dart';

class DoctorPdfPrimitives {
  const DoctorPdfPrimitives._();

  static String pdfText(String input) => input;

  static pw.Widget sectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 4),
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300),
        ),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 9,
          letterSpacing: 1.4,
          color: PdfColors.grey700,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget legend(String hex, String label) {
    return pw.Row(
      children: [
        pw.Container(width: 14, height: 8, color: PdfColor.fromHex(hex)),
        pw.SizedBox(width: 5),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
      ],
    );
  }

  static pw.Widget emptyBox(String text) {
    return pw.Container(
      height: 46,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Text(
        pdfText(text),
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      ),
    );
  }

  static pw.Widget episodeMetric(String label, String value) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(7),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label.toUpperCase(),
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            pdfText(value),
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.TableRow periodRow(List<String> cells, {bool header = false}) {
    return pw.TableRow(
      decoration:
          header ? const pw.BoxDecoration(color: PdfColors.grey100) : null,
      children: [
        for (final cell in cells)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: pw.Text(
              pdfText(cell),
              style: pw.TextStyle(
                fontSize: header ? 8 : 9,
                fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: header ? PdfColors.grey700 : PdfColors.black,
              ),
            ),
          ),
      ],
    );
  }

  static PdfColor rangeColor(ReportRangeTone tone) =>
      DoctorGlucoseReportPdfTheme.rangeColor(tone);

  static PdfColor metricColor(ReportMetricTone tone) =>
      DoctorGlucoseReportPdfTheme.metricColor(tone);
}
