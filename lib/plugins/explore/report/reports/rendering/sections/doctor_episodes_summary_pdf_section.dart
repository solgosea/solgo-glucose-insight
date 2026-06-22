import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/report_view_model.dart';
import '../primitives/doctor_pdf_primitives.dart';

class DoctorEpisodesSummaryPdfSection {
  const DoctorEpisodesSummaryPdfSection._();

  static pw.Widget build(ReportViewModel vm) {
    final summary = vm.episodesSummary;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        DoctorPdfPrimitives.sectionTitle('Episodes Summary'),
        if (!summary.hasData)
          DoctorPdfPrimitives.emptyBox(summary.summaryText)
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Text(
                  summary.summaryText,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    DoctorPdfPrimitives.episodeMetric(
                      'High episodes',
                      '${summary.highCount}',
                    ),
                    DoctorPdfPrimitives.episodeMetric(
                      'Low episodes',
                      '${summary.lowCount}',
                    ),
                    DoctorPdfPrimitives.episodeMetric(
                      'Avg high',
                      summary.avgHighDurationLabel,
                    ),
                    DoctorPdfPrimitives.episodeMetric(
                      'Avg low',
                      summary.avgLowDurationLabel,
                    ),
                    DoctorPdfPrimitives.episodeMetric(
                      'Nocturnal lows',
                      '${summary.nocturnalLowCount}',
                    ),
                    DoctorPdfPrimitives.episodeMetric(
                      'Highest',
                      summary.highestLabel,
                    ),
                    DoctorPdfPrimitives.episodeMetric(
                      'Lowest',
                      summary.lowestLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
