import 'dart:typed_data';

import 'package:printing/printing.dart';

import '../domain/report_context.dart';
import '../domain/report_snapshot.dart';
import 'report_export_action.dart';
import 'report_export_result.dart';
import 'report_runtime.dart';

class ReportExportService {
  final ReportRuntime runtime;

  const ReportExportService({
    required this.runtime,
  });

  Future<ReportExportResult> exportPdf({
    required ReportContext context,
    required String Function(ReportSnapshot snapshot) filenameBuilder,
    required ReportExportAction action,
  }) async {
    try {
      final snapshot = await runtime.buildSnapshot(context);
      final bytes = await runtime.pdfRenderer.build(snapshot);
      final data = Uint8List.fromList(bytes);
      final filename = filenameBuilder(snapshot);
      switch (action) {
        case ReportExportAction.save:
          await Printing.layoutPdf(name: filename, onLayout: (_) async => data);
        case ReportExportAction.share:
          await Printing.sharePdf(bytes: data, filename: filename);
      }
      return ReportExportResult.success(filename);
    } catch (error) {
      return ReportExportResult.failure(error);
    }
  }
}
