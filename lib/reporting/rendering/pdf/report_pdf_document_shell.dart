import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/report_snapshot.dart';
import 'report_pdf_theme.dart';

class ReportPdfDocumentShell {
  const ReportPdfDocumentShell();

  pw.Document create(ReportSnapshot snapshot) {
    return pw.Document(
      title: snapshot.title,
      author: 'SolgoInsight',
      creator: 'SolgoInsight',
    );
  }

  pw.PageTheme pageTheme() {
    return pw.PageTheme(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 30),
      buildBackground: (_) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Container(color: ReportPdfTheme.bg),
      ),
    );
  }

  pw.Widget footer(ReportSnapshot snapshot) {
    return pw.Text(
      'Generated locally on this device. Shared only when you choose. '
      'For informational review only. Not medical advice.',
      style: ReportPdfTheme.label.copyWith(fontSize: 7),
      textAlign: pw.TextAlign.center,
    );
  }
}
