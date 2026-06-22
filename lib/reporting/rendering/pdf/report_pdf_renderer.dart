import '../../domain/report_snapshot.dart';

abstract class ReportPdfRenderer {
  Future<List<int>> build(ReportSnapshot snapshot);
}
