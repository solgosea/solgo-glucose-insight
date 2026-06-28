import '../../domain/report_data_quality.dart';
import '../../domain/sections/report_ranges_section.dart';
import '../../models/report_period.dart';

class ReportRangesSectionBuilder {
  const ReportRangesSectionBuilder();

  ReportRangesSection build({
    required ReportDataQuality quality,
    required ReportPeriod period,
    required int periodDays,
  }) {
    return ReportRangesSection(
      quality: quality,
      period: period,
      periodDays: periodDays,
    );
  }
}
