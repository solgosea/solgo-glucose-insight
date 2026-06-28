import '../../../application/analysis/analysis_facade.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../domain/history_time_filter.dart';

class HistoryEngineInput {
  final DateTime selectedDay;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final List<GlucoseReading> readings;
  final List<GlucoseEvent> events;
  final AnalysisTirResult? tir;
  final bool isToday;
  final AppSettings settings;
  final HistoryTimeFilter? timeFilter;

  const HistoryEngineInput({
    required this.selectedDay,
    required this.rangeStart,
    required this.rangeEnd,
    required this.readings,
    required this.events,
    required this.tir,
    required this.isToday,
    required this.settings,
    this.timeFilter,
  });
}
