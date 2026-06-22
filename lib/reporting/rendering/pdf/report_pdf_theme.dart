import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportPdfTheme {
  static const bg = PdfColor.fromInt(0xFFFFFFFF);
  static const ink = PdfColor.fromInt(0xFF22342D);
  static const muted = PdfColor.fromInt(0xFF61746B);
  static const panel = PdfColor.fromInt(0xFFF8FBF7);
  static const panelAlt = PdfColor.fromInt(0xFFF2F7F1);
  static const line = PdfColor.fromInt(0xFFDDE8E1);
  static const green = PdfColor.fromInt(0xFF1A9E5C);
  static const amber = PdfColor.fromInt(0xFFB87518);
  static const rose = PdfColor.fromInt(0xFFC74742);
  static const blue = PdfColor.fromInt(0xFF3277BE);

  static pw.TextStyle get title => pw.TextStyle(
        fontSize: 28,
        fontWeight: pw.FontWeight.bold,
        color: ink,
      );

  static pw.TextStyle get h2 => pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
        color: ink,
      );

  static pw.TextStyle get label => pw.TextStyle(
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
        color: muted,
      );

  static pw.TextStyle get body => const pw.TextStyle(
        fontSize: 9,
        color: ink,
        lineSpacing: 2,
      );
}
