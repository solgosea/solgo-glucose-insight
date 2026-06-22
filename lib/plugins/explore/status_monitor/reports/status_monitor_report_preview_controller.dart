import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';
import 'package:smart_xdrip/reporting/application/report_runtime.dart';
import 'package:smart_xdrip/reporting/domain/report_context.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

import '../application/status_monitor_service.dart';
import 'rendering/status_monitor_report_pdf_renderer.dart';
import 'status_monitor_report_adapter.dart';
import 'status_monitor_report_filename_builder.dart';
import 'status_monitor_report_provider.dart';

class StatusMonitorReportPreviewController extends ChangeNotifier {
  final StatusMonitorService service;
  final StatusMonitorReportFilenameBuilder filenameBuilder;
  final StatusMonitorReportPdfRenderer pdfRenderer;

  ReportSnapshot? snapshot;
  Object? error;
  bool loading = false;
  bool exporting = false;

  StatusMonitorReportPreviewController({
    required this.service,
    this.filenameBuilder = const StatusMonitorReportFilenameBuilder(),
    this.pdfRenderer = const StatusMonitorReportPdfRenderer(),
  });

  Future<void> load({Locale? locale}) async {
    if (loading) return;
    loading = true;
    error = null;
    notifyListeners();
    try {
      final settings = service.settingsProvider();
      final runtime = _runtime();
      final reportContext = StatusMonitorReportProvider.contextFor(
        now: DateTime.now(),
        unit: settings.unit,
        sourceLabel: _sourceLabel(),
      );
      snapshot = await runtime.buildSnapshot(
        ReportContext(
          range: reportContext.range,
          unit: reportContext.unit,
          privacyLevel: reportContext.privacyLevel,
          locale: locale ?? reportContext.locale,
          sourceLabel: reportContext.sourceLabel,
          options: reportContext.options,
        ),
      );
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
      final filename = filenameBuilder.build(generatedAt: current.generatedAt);
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
      provider: StatusMonitorReportProvider(
        service: service,
        adapter: StatusMonitorReportAdapter(now: DateTime.now),
      ),
      pdfRenderer: pdfRenderer,
    );
  }

  String _sourceLabel() {
    final settings = service.settingsProvider();
    if (settings.xdripSyncEnabled) return 'xDrip+ Local';
    if (settings.nightscoutSyncEnabled) return 'Nightscout';
    return 'Configured source';
  }
}
