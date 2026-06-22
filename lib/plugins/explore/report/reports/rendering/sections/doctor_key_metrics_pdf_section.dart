import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report_view_model.dart';
import '../primitives/doctor_pdf_primitives.dart';

class DoctorKeyMetricsPdfSection {
  const DoctorKeyMetricsPdfSection._();

  static pw.Widget build(ReportViewModel vm) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(child: _ranges(vm)),
        pw.SizedBox(width: 16),
        pw.Expanded(child: _metrics(vm)),
      ],
    );
  }

  static pw.Widget _ranges(ReportViewModel vm) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        DoctorPdfPrimitives.sectionTitle('Time in Ranges'),
        pw.Container(
          height: 14,
          decoration:
              pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(3)),
          child: pw.Row(
            children: [
              for (final range in vm.ranges)
                pw.Expanded(
                  flex: range.percent.round().clamp(1, 100),
                  child: pw.Container(
                    color: DoctorPdfPrimitives.rangeColor(range.tone),
                  ),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        for (final range in vm.ranges)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 8,
                  height: 8,
                  decoration: pw.BoxDecoration(
                    color: DoctorPdfPrimitives.rangeColor(range.tone),
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(width: 5),
                pw.Expanded(
                  child: pw.Text(
                    '${range.label} ${DoctorPdfPrimitives.pdfText(range.thresholdLabel)}'
                    '${range.levelLabel == null ? '' : '  ${range.levelLabel}'}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Text(
                  '${range.percent.toStringAsFixed(0)}%',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: DoctorPdfPrimitives.rangeColor(range.tone),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Text(
                  '${range.minutesPerDay} min/day',
                  style:
                      const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static pw.Widget _metrics(ReportViewModel vm) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        DoctorPdfPrimitives.sectionTitle('Key Metrics'),
        pw.Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final metric in vm.metrics)
              pw.Container(
                width: 105,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      metric.label.toUpperCase(),
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      DoctorPdfPrimitives.pdfText(metric.value),
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: DoctorPdfPrimitives.metricColor(metric.tone),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      DoctorPdfPrimitives.pdfText(metric.unit),
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
