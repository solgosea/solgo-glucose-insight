import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report_view_model.dart';
import '../primitives/doctor_pdf_primitives.dart';

class DoctorDisclaimerPdfSection {
  const DoctorDisclaimerPdfSection._();

  static pw.Widget build(ReportViewModel vm) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'CGM readings only - No insulin or carb data included\n'
            'Not a medical device - For informational purposes only',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
          pw.Text(
            'SolgoInsight - local report\nPrinted ${DoctorPdfPrimitives.pdfText(vm.header.generatedLabel)}',
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }
}
