import 'package:pdf/widgets.dart' as pw;

import '../../../charts/report_svg_chart_builder.dart';
import '../../../models/report_view_model.dart';
import '../primitives/doctor_pdf_primitives.dart';

class DoctorAgpChartPdfSection {
  final ReportSvgChartBuilder chartBuilder;

  const DoctorAgpChartPdfSection({
    this.chartBuilder = const ReportSvgChartBuilder(),
  });

  pw.Widget build(ReportViewModel vm) {
    final svg = chartBuilder.agp(
      slots: vm.agpSlots,
      settings: vm.settings,
      width: 722,
      height: 160,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        DoctorPdfPrimitives.sectionTitle(
          'Ambulatory Glucose Profile (AGP) - ${vm.selectedPeriod.days} days',
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            DoctorPdfPrimitives.legend('#1a9e5c', 'Median (p50)'),
            pw.SizedBox(width: 12),
            DoctorPdfPrimitives.legend('#7dc79f', 'IQR (p25-p75)'),
            pw.SizedBox(width: 12),
            DoctorPdfPrimitives.legend('#b9dec7', 'p10-p90'),
          ],
        ),
        pw.SizedBox(height: 6),
        if (vm.agpSlots.isEmpty)
          DoctorPdfPrimitives.emptyBox(vm.emptyText)
        else
          pw.SvgImage(svg: svg),
      ],
    );
  }
}
