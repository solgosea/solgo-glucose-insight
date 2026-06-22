import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';
import 'package:smart_xdrip/reporting/application/report_export_result.dart';
import 'package:smart_xdrip/reporting/application/report_export_service.dart';
import 'package:smart_xdrip/reporting/application/report_runtime.dart';

import '../../application/episode_detail_service.dart';
import '../../domain/episode_detail_entry_intent.dart';
import '../rendering/high/high_episode_report_pdf_renderer.dart';
import 'high_episode_report_adapter.dart';
import 'high_episode_report_filename_builder.dart';
import 'high_episode_report_provider.dart';

class HighEpisodeReportExportController {
  final EpisodeDetailEntryIntent intent;
  final EpisodeDetailService service;
  final AnalysisFacade Function() facadeProvider;
  final ReportExportService? exportService;
  final HighEpisodeReportFilenameBuilder filenameBuilder;

  HighEpisodeReportExportController({
    required this.intent,
    EpisodeDetailService? service,
    AnalysisFacade Function()? facadeProvider,
    this.exportService,
    this.filenameBuilder = const HighEpisodeReportFilenameBuilder(),
  })  : facadeProvider = facadeProvider ?? AnalysisFacade.current,
        service = service ??
            EpisodeDetailService(
              facadeProvider: facadeProvider ?? AnalysisFacade.current,
            );

  Future<ReportExportResult> sharePdf() async {
    final facade = facadeProvider();
    final provider = HighEpisodeReportProvider(
      intent: intent,
      service: service,
      facadeProvider: facadeProvider,
      adapter: const HighEpisodeReportAdapter(),
    );
    final runtime = ReportRuntime(
      provider: provider,
      pdfRenderer: const HighEpisodeReportPdfRenderer(),
    );
    final exporter = exportService ?? ReportExportService(runtime: runtime);
    final context = HighEpisodeReportProvider.defaultContext(
      intent: intent,
      facade: facade,
    );
    return exporter.exportPdf(
      context: context,
      action: ReportExportAction.share,
      filenameBuilder: (snapshot) => filenameBuilder.build(snapshot.range.end),
    );
  }
}
