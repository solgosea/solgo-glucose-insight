import '../domain/report_context.dart';
import '../domain/report_provider.dart';
import '../domain/report_snapshot.dart';
import '../rendering/pdf/report_pdf_renderer.dart';

class ReportRuntime {
  final ReportProvider provider;
  final ReportPdfRenderer pdfRenderer;

  const ReportRuntime({
    required this.provider,
    required this.pdfRenderer,
  });

  Future<ReportSnapshot> buildSnapshot(ReportContext context) {
    return provider.buildReport(context);
  }

  Future<List<int>> buildPdf(ReportContext context) async {
    final snapshot = await buildSnapshot(context);
    return pdfRenderer.build(snapshot);
  }
}
