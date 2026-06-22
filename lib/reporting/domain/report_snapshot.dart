import 'package:smart_xdrip/domain/entities/app_settings.dart';

import 'report_data_quality_summary.dart';
import 'report_date_range.dart';
import 'report_disclaimer.dart';
import 'report_finding.dart';
import 'report_section.dart';

class ReportSnapshot {
  final String reportId;
  final String title;
  final ReportDateRange range;
  final DateTime generatedAt;
  final String sourceLabel;
  final GlucoseUnit unit;
  final ReportDataQualitySummary dataQuality;
  final List<ReportSection> sections;
  final List<ReportFinding> findings;
  final ReportDisclaimer disclaimer;

  const ReportSnapshot({
    required this.reportId,
    required this.title,
    required this.range,
    required this.generatedAt,
    required this.sourceLabel,
    required this.unit,
    required this.dataQuality,
    required this.sections,
    required this.findings,
    required this.disclaimer,
  });
}
