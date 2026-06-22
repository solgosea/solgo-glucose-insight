import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report_view_model.dart';
import '../primitives/doctor_pdf_primitives.dart';

class DoctorPeriodAnalysisPdfSection {
  const DoctorPeriodAnalysisPdfSection._();

  static pw.Widget build(ReportViewModel vm) {
    final analysis = vm.periodAnalysis;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        DoctorPdfPrimitives.sectionTitle('Period Analysis'),
        if (!analysis.hasData)
          DoctorPdfPrimitives.emptyBox(analysis.summaryText)
        else ...[
          pw.Text(
            analysis.summaryText,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: .5),
            columnWidths: const {
              0: pw.FlexColumnWidth(1.2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(.8),
              3: pw.FlexColumnWidth(.8),
              4: pw.FlexColumnWidth(1),
            },
            children: [
              DoctorPdfPrimitives.periodRow(
                ['Period', 'Avg', 'TIR', 'CV', 'Peak'],
                header: true,
              ),
              for (final row in analysis.rows)
                DoctorPdfPrimitives.periodRow([
                  row.label,
                  row.averageLabel,
                  row.tirLabel,
                  row.cvLabel,
                  row.peakLabel,
                ]),
            ],
          ),
        ],
      ],
    );
  }
}
