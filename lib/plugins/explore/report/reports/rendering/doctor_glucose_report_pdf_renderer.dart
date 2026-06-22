import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';
import 'package:smart_xdrip/reporting/rendering/pdf/report_pdf_renderer.dart';

import '../doctor_glucose_report_payloads.dart';
import '../doctor_glucose_report_section_keys.dart';
import 'doctor_glucose_report_pdf_document_shell.dart';
import 'sections/doctor_agp_chart_pdf_section.dart';
import 'sections/doctor_daily_curves_pdf_section.dart';
import 'sections/doctor_disclaimer_pdf_section.dart';
import 'sections/doctor_episodes_summary_pdf_section.dart';
import 'sections/doctor_key_metrics_pdf_section.dart';
import 'sections/doctor_period_analysis_pdf_section.dart';
import 'sections/doctor_report_header_pdf_section.dart';

class DoctorGlucoseReportPdfRenderer implements ReportPdfRenderer {
  final DoctorGlucoseReportPdfDocumentShell documentShell;
  final DoctorAgpChartPdfSection agpSection;
  final DoctorDailyCurvesPdfSection dailyCurvesSection;

  const DoctorGlucoseReportPdfRenderer({
    this.documentShell = const DoctorGlucoseReportPdfDocumentShell(),
    this.agpSection = const DoctorAgpChartPdfSection(),
    this.dailyCurvesSection = const DoctorDailyCurvesPdfSection(),
  });

  @override
  Future<Uint8List> build(ReportSnapshot snapshot) {
    final payload = _documentPayload(snapshot);
    if (payload == null) {
      throw StateError(
          'Doctor glucose report snapshot is missing document payload.');
    }
    final viewModel = payload.viewModel;
    return documentShell.build(
      sections: [
        DoctorReportHeaderPdfSection.build(viewModel),
        pw.SizedBox(height: 14),
        if (_enabled(snapshot, DoctorGlucoseReportSectionKeys.keyMetrics))
          DoctorKeyMetricsPdfSection.build(viewModel),
        if (_enabled(snapshot, DoctorGlucoseReportSectionKeys.agpChart)) ...[
          pw.SizedBox(height: 16),
          agpSection.build(viewModel),
        ],
        if (_enabled(snapshot, DoctorGlucoseReportSectionKeys.dailyCurves)) ...[
          pw.SizedBox(height: 16),
          dailyCurvesSection.build(viewModel),
        ],
        if (_enabled(
            snapshot, DoctorGlucoseReportSectionKeys.periodAnalysis)) ...[
          pw.SizedBox(height: 16),
          DoctorPeriodAnalysisPdfSection.build(viewModel),
        ],
        if (_enabled(
            snapshot, DoctorGlucoseReportSectionKeys.episodesSummary)) ...[
          pw.SizedBox(height: 16),
          DoctorEpisodesSummaryPdfSection.build(viewModel),
        ],
        pw.Spacer(),
        DoctorDisclaimerPdfSection.build(viewModel),
      ],
    );
  }

  bool _enabled(ReportSnapshot snapshot, String rendererKey) {
    return snapshot.sections.any(
      (section) => section.rendererKey == rendererKey,
    );
  }

  DoctorGlucoseReportDocumentPayload? _documentPayload(
    ReportSnapshot snapshot,
  ) {
    for (final section in snapshot.sections) {
      if (section.rendererKey != DoctorGlucoseReportSectionKeys.document) {
        continue;
      }
      final payload = section.payload;
      if (payload is DoctorGlucoseReportDocumentPayload) {
        return payload;
      }
    }
    return null;
  }
}
