import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class LowEpisodeReportPdfTheme {
  static const bg = PdfColor.fromInt(0xFFFFFFFF);
  static const ink = PdfColor.fromInt(0xFF22342D);
  static const muted = PdfColor.fromInt(0xFF61746B);
  static const softInk = PdfColor.fromInt(0xFF7B8E85);
  static const soft = PdfColor.fromInt(0xFFF5FAF6);
  static const card = PdfColor.fromInt(0xFFF8FBF7);
  static const panel = PdfColor.fromInt(0xFFFBFCFB);
  static const line = PdfColor.fromInt(0xFFDDE8E1);
  static const line2 = PdfColor.fromInt(0xFFCBD7D0);
  static const green = PdfColor.fromInt(0xFF1A9E5C);
  static const amber = PdfColor.fromInt(0xFFB87518);
  static const amberSoft = PdfColor.fromInt(0xFFFFF4DF);
  static const blue = PdfColor.fromInt(0xFF2D7AB0);
  static const cyan = PdfColor.fromInt(0xFF5DB8F0);
  static const blueSoft = PdfColor.fromInt(0xFFE9F3FA);

  static pw.TextStyle get eyebrow => pw.TextStyle(
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
        color: green,
        letterSpacing: 1.2,
      );

  static pw.TextStyle get h1 => pw.TextStyle(
        fontSize: 28,
        fontWeight: pw.FontWeight.bold,
        color: ink,
      );

  static pw.TextStyle get section => pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: muted,
        letterSpacing: 1.1,
      );

  static pw.TextStyle get label => pw.TextStyle(
        fontSize: 7,
        fontWeight: pw.FontWeight.bold,
        color: muted,
      );

  static pw.TextStyle get body => const pw.TextStyle(
        fontSize: 8.5,
        color: ink,
        lineSpacing: 2,
      );
}
