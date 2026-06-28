import '../../../../../domain/entities/glucose_reading.dart';
import '../../models/report_period.dart';
import '../report_data_quality.dart';

class ReportHeaderSection {
  final List<GlucoseReading> readings;
  final ReportPeriod period;
  final DateTime start;
  final DateTime end;
  final DateTime generatedAt;
  final ReportDataQuality quality;

  const ReportHeaderSection({
    required this.readings,
    required this.period,
    required this.start,
    required this.end,
    required this.generatedAt,
    required this.quality,
  });
}
