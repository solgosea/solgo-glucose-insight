import '../../models/report_period.dart';
import '../report_data_quality.dart';

class ReportRangesSection {
  final ReportDataQuality quality;
  final ReportPeriod period;
  final int periodDays;

  const ReportRangesSection({
    required this.quality,
    required this.period,
    required this.periodDays,
  });
}
