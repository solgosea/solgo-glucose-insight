import 'package:pdf/pdf.dart';

class StatusMonitorReportPdfTheme {
  static const sheet = PdfColors.white;
  static const ink = PdfColor.fromInt(0xff15201a);
  static const muted = PdfColor.fromInt(0xff61746b);
  static const soft = PdfColor.fromInt(0xff7b8e85);
  static const line = PdfColor.fromInt(0xffdfe6e2);
  static const panel = PdfColor.fromInt(0xfff7f9f8);
  static const panel2 = PdfColor.fromInt(0xfffbfcfb);
  static const green = PdfColor.fromInt(0xff1a9e5c);
  static const amber = PdfColor.fromInt(0xffb87518);
  static const rose = PdfColor.fromInt(0xffc74742);
  static const blue = PdfColor.fromInt(0xff2d7ab0);

  const StatusMonitorReportPdfTheme._();

  static PdfColor tone(String tone) {
    return switch (tone) {
      'ok' => green,
      'watch' => amber,
      'issue' => rose,
      'unknown' => muted,
      _ => ink,
    };
  }

  static PdfColor toneBg(String tone) {
    return switch (tone) {
      'ok' => const PdfColor.fromInt(0xffedf7f0),
      'watch' => const PdfColor.fromInt(0xfffff7e8),
      'issue' => const PdfColor.fromInt(0xfffff0ef),
      'unknown' => const PdfColor.fromInt(0xfff1f4f2),
      _ => panel,
    };
  }

  static PdfColor timelineToneBg(String tone) {
    return switch (tone) {
      'ok' => const PdfColor.fromInt(0xffcdeed8),
      'watch' => const PdfColor.fromInt(0xffffdda3),
      'issue' => const PdfColor.fromInt(0xffffc6c2),
      'unknown' => const PdfColor.fromInt(0xffe2e9e5),
      _ => panel,
    };
  }

  static PdfColor timelineToneBorder(String tone) {
    return switch (tone) {
      'ok' => const PdfColor.fromInt(0xff8fd4a6),
      'watch' => const PdfColor.fromInt(0xffe7b64f),
      'issue' => const PdfColor.fromInt(0xffe68d87),
      'unknown' => const PdfColor.fromInt(0xffc8d4ce),
      _ => line,
    };
  }
}
