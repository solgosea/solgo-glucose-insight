import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../models/report_period.dart';

class ReportEngineInput {
  final List<GlucoseReading> readings;
  final AppSettings settings;
  final ReportPeriod period;
  final DateTime start;
  final DateTime end;
  final DateTime generatedAt;

  const ReportEngineInput({
    required this.readings,
    required this.settings,
    required this.period,
    required this.start,
    required this.end,
    required this.generatedAt,
  });
}
