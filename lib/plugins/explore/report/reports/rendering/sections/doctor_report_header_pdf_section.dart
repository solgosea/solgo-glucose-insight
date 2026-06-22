import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report_view_model.dart';
import '../primitives/doctor_pdf_primitives.dart';

class DoctorReportHeaderPdfSection {
  const DoctorReportHeaderPdfSection._();

  static pw.Widget build(ReportViewModel vm) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 2),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'SolgoInsight',
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    const pw.TextSpan(
                      text: '  Glucose Report',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                '${DoctorPdfPrimitives.pdfText(vm.header.periodTitle)}: '
                '${DoctorPdfPrimitives.pdfText(vm.header.periodLabel)}',
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
              pw.Text(
                '${vm.header.readingsLabel} - ${vm.header.coverageLabel}',
                style:
                    const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.Text(
            DoctorPdfPrimitives.pdfText(
              '${vm.header.dataSourceTitle}: ${vm.header.dataSourceLabel}\n'
              '${vm.header.targetRangeTitle}: ${vm.header.targetRangeLabel}\n'
              '${vm.header.generatedTitle}: ${vm.header.generatedLabel}',
            ),
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }
}
