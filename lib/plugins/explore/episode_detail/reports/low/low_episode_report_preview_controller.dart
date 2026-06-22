import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';
import 'package:smart_xdrip/reporting/application/report_runtime.dart';
import 'package:smart_xdrip/reporting/domain/report_context.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../../application/episode_detail_service.dart';
import '../../domain/episode_detail_entry_intent.dart';
import '../rendering/low/low_episode_report_pdf_renderer.dart';
import 'low_episode_report_adapter.dart';
import 'low_episode_report_filename_builder.dart';
import 'low_episode_report_provider.dart';

class LowEpisodeReportPreviewController extends ChangeNotifier {
  final EpisodeDetailEntryIntent intent;
  final EpisodeDetailService service;
  final AnalysisFacade Function() facadeProvider;
  final LowEpisodeReportFilenameBuilder filenameBuilder;
  final LowEpisodeReportPdfRenderer pdfRenderer;

  ReportSnapshot? snapshot;
  Object? error;
  bool loading = false;
  bool exporting = false;

  LowEpisodeReportPreviewController({
    required this.intent,
    EpisodeDetailService? service,
    AnalysisFacade Function()? facadeProvider,
    this.filenameBuilder = const LowEpisodeReportFilenameBuilder(),
    this.pdfRenderer = const LowEpisodeReportPdfRenderer(),
  })  : facadeProvider = facadeProvider ?? AnalysisFacade.current,
        service = service ??
            EpisodeDetailService(
              facadeProvider: facadeProvider ?? AnalysisFacade.current,
            );

  Future<void> load({Locale? locale}) async {
    if (loading) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final runtime = _runtime();
      final baseContext = LowEpisodeReportProvider.defaultContext(
        intent: intent,
        facade: facadeProvider(),
      );
      final context = ReportContext(
        range: baseContext.range,
        unit: baseContext.unit,
        privacyLevel: baseContext.privacyLevel,
        locale: locale ?? baseContext.locale,
        sourceLabel: baseContext.sourceLabel,
        options: baseContext.options,
      );
      snapshot = await runtime.buildSnapshot(context);
    } catch (err) {
      error = err;
      snapshot = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> export(ReportExportAction action) async {
    final current = snapshot;
    if (current == null || exporting) return false;
    exporting = true;
    notifyListeners();
    try {
      final bytes = Uint8List.fromList(await pdfRenderer.build(current));
      final filename = filenameBuilder.build(current.range.end);
      switch (action) {
        case ReportExportAction.save:
          await Printing.layoutPdf(
              name: filename, onLayout: (_) async => bytes);
        case ReportExportAction.share:
          await Printing.sharePdf(bytes: bytes, filename: filename);
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      exporting = false;
      notifyListeners();
    }
  }

  ReportRuntime _runtime() {
    return ReportRuntime(
      provider: LowEpisodeReportProvider(
        intent: intent,
        service: service,
        facadeProvider: facadeProvider,
        adapter: const LowEpisodeReportAdapter(),
      ),
      pdfRenderer: pdfRenderer,
    );
  }
}
