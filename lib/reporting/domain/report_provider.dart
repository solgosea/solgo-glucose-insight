import 'report_context.dart';
import 'report_format.dart';
import 'report_privacy_level.dart';
import 'report_snapshot.dart';

abstract class ReportProvider {
  String get id;
  String get title;
  Set<ReportFormat> get supportedFormats;
  ReportPrivacyLevel get defaultPrivacyLevel;

  Future<ReportSnapshot> buildReport(ReportContext context);
}
