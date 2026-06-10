import '../entities/glucose_event.dart';
import '../entities/glucose_reading.dart';
import 'daily_glucose_summary.dart';
import 'period_glucose_summary.dart';

class AnalysisSnapshot {
  final DateTime generatedAt;
  final DateTime windowStart;
  final DateTime windowEnd;
  final List<GlucoseReading> readings;
  final List<DailyGlucoseSummary> dailySummaries;
  final List<PeriodGlucoseSummary> periodSummaries;
  final List<GlucoseEvent> events;

  const AnalysisSnapshot({
    required this.generatedAt,
    required this.windowStart,
    required this.windowEnd,
    required this.readings,
    required this.dailySummaries,
    required this.periodSummaries,
    required this.events,
  });

  int get readingDays => dailySummaries.length;
}
