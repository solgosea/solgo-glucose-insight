import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../charts/report_svg_chart_builder.dart';
import '../../../models/report_view_model.dart';
import '../primitives/doctor_pdf_primitives.dart';

class DoctorDailyCurvesPdfSection {
  final ReportSvgChartBuilder chartBuilder;

  const DoctorDailyCurvesPdfSection({
    this.chartBuilder = const ReportSvgChartBuilder(),
  });

  pw.Widget build(ReportViewModel vm) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        DoctorPdfPrimitives.sectionTitle('Daily Glucose - last 14 days'),
        for (final day in vm.dailyCurves)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Row(
              children: [
                pw.SizedBox(
                  width: 42,
                  child: pw.Text(
                    day.dayLabel,
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    height: 20,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                    child: day.sparse
                        ? pw.Center(
                            child: pw.Text(
                              'sparse data - excluded',
                              style: const pw.TextStyle(
                                fontSize: 8,
                                color: PdfColors.grey500,
                              ),
                            ),
                          )
                        : pw.SvgImage(
                            svg: chartBuilder.dailyCurve(
                              day: day,
                              settings: vm.settings,
                            ),
                          ),
                  ),
                ),
                pw.SizedBox(
                  width: 38,
                  child: pw.Text(
                    day.tir == null ? '-' : '${day.tir!.toStringAsFixed(0)}%',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: day.tir == null
                          ? PdfColors.grey500
                          : day.tir! >= 70
                              ? PdfColor.fromHex('#1a9e5c')
                              : day.tir! >= 55
                                  ? PdfColor.fromHex('#d4861a')
                                  : PdfColor.fromHex('#c94040'),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
