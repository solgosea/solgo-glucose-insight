import '../engine/report_engine_output.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';

class DoctorGlucoseReportDocumentPayload {
  final ReportEngineOutput output;
  final ReportViewModel viewModel;
  final List<ReportSectionToggle> sections;

  const DoctorGlucoseReportDocumentPayload({
    required this.output,
    required this.viewModel,
    required this.sections,
  });
}

class DoctorGlucoseReportSectionPayload {
  final ReportSectionKey key;
  final Object section;

  const DoctorGlucoseReportSectionPayload({
    required this.key,
    required this.section,
  });
}
