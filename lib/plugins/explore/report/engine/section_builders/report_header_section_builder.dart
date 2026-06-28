import '../../domain/report_data_quality.dart';
import '../../domain/sections/report_header_section.dart';
import '../../models/report_period.dart';
import '../../../../../domain/entities/glucose_reading.dart';

class ReportHeaderSectionBuilder {
  const ReportHeaderSectionBuilder();

  ReportHeaderSection build({
    required List<GlucoseReading> readings,
    required ReportPeriod period,
    required DateTime start,
    required DateTime end,
    required DateTime generatedAt,
    required ReportDataQuality quality,
  }) {
    return ReportHeaderSection(
      readings: readings,
      period: period,
      start: start,
      end: end,
      generatedAt: generatedAt,
      quality: quality,
    );
  }
}
