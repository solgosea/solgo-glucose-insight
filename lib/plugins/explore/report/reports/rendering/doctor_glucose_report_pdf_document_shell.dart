import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import 'doctor_glucose_report_pdf_theme.dart';

class DoctorGlucoseReportPdfDocumentShell {
  const DoctorGlucoseReportPdfDocumentShell();

  Future<Uint8List> build({
    required List<pw.Widget> sections,
  }) {
    final doc = pw.Document(
      title: 'SolgoInsight Glucose Report',
      author: 'SolgoInsight',
      creator: 'SolgoInsight',
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: DoctorGlucoseReportPdfTheme.pageFormat,
        margin: const pw.EdgeInsets.fromLTRB(36, 32, 36, 28),
        build: (_) => sections,
      ),
    );
    return doc.save();
  }
}
