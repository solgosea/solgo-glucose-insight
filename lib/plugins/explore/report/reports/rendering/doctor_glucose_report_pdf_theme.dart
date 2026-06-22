import 'package:pdf/pdf.dart';

import '../../models/report_view_model.dart';

class DoctorGlucoseReportPdfTheme {
  static const pageFormat = PdfPageFormat.a4;

  const DoctorGlucoseReportPdfTheme._();

  static PdfColor rangeColor(ReportRangeTone tone) {
    return switch (tone) {
      ReportRangeTone.veryHigh => PdfColor.fromHex('#c94040'),
      ReportRangeTone.high => PdfColor.fromHex('#d4861a'),
      ReportRangeTone.inRange => PdfColor.fromHex('#1a9e5c'),
      ReportRangeTone.low => PdfColor.fromHex('#5aaddf'),
      ReportRangeTone.veryLow => PdfColor.fromHex('#2563a8'),
    };
  }

  static PdfColor metricColor(ReportMetricTone tone) {
    return switch (tone) {
      ReportMetricTone.green => PdfColor.fromHex('#1a9e5c'),
      ReportMetricTone.amber => PdfColor.fromHex('#b07a1a'),
      ReportMetricTone.blue => PdfColor.fromHex('#2d7ab0'),
      ReportMetricTone.neutral => PdfColors.black,
    };
  }
}
