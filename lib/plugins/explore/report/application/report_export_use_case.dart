import '../models/report_view_model.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';
import 'package:smart_xdrip/reporting/application/report_export_service.dart';
import 'package:smart_xdrip/reporting/application/report_runtime.dart';

import '../reports/doctor_glucose_report_filename_builder.dart';
import '../reports/doctor_glucose_report_provider.dart';
import '../reports/rendering/doctor_glucose_report_pdf_renderer.dart';

class ReportExportUseCase {
  final AnalysisFacade Function() facadeProvider;
  final DoctorGlucoseReportProvider? provider;
  final DoctorGlucoseReportPdfRenderer pdfRenderer;
  final DoctorGlucoseReportFilenameBuilder filenameBuilder;

  const ReportExportUseCase({
    this.facadeProvider = AnalysisFacade.current,
    this.provider,
    this.pdfRenderer = const DoctorGlucoseReportPdfRenderer(),
    this.filenameBuilder = const DoctorGlucoseReportFilenameBuilder(),
  });

  Future<void> execute(
    ReportViewModel viewModel, {
    required ReportExportAction action,
  }) async {
    final reportProvider = provider ??
        DoctorGlucoseReportProvider(
          facadeProvider: facadeProvider,
        );
    final runtime = ReportRuntime(
      provider: reportProvider,
      pdfRenderer: pdfRenderer,
    );
    final exportService = ReportExportService(runtime: runtime);
    final result = await exportService.exportPdf(
      context: smartDoctorGlucoseReportContext(
        period: viewModel.selectedPeriod,
        sections: viewModel.sections,
        sourceLabel: viewModel.header.dataSourceLabel,
        unit: viewModel.settings.unit,
      ),
      filenameBuilder: filenameBuilder.build,
      action: action,
    );
    if (!result.success) {
      throw result.error ?? StateError('Could not export glucose report');
    }
  }
}
