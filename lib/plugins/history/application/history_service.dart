import '../../../application/analysis/analysis_facade.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../domain/history_time_filter.dart';
import '../engine/history_engine.dart';
import '../engine/history_engine_input.dart';
import '../engine/history_engine_output.dart';
import '../l10n/generated/history_localizations.dart';
import '../mappers/history_view_model_mapper.dart';
import '../models/history_view_model.dart';

class HistoryService {
  final HistoryEngine engine;
  final HistoryViewModelMapper mapper;

  const HistoryService({
    this.engine = const HistoryEngine(),
    this.mapper = const HistoryViewModelMapper(),
  });

  HistoryEngineOutput buildOutput({
    required DateTime selectedDay,
    required List<GlucoseReading> readings,
    required List<GlucoseEvent> events,
    required AnalysisTirResult? tir,
    required bool isToday,
    required AppSettings settings,
    HistoryTimeFilter? timeFilter,
  }) {
    return engine.run(
      HistoryEngineInput(
        selectedDay: selectedDay,
        readings: readings,
        events: events,
        tir: tir,
        isToday: isToday,
        settings: settings,
        timeFilter: timeFilter,
      ),
    );
  }

  HistoryViewModel buildViewModel({
    required DateTime selectedDay,
    required List<GlucoseReading> readings,
    required List<GlucoseEvent> events,
    required AnalysisTirResult? tir,
    required bool isToday,
    required AppSettings settings,
    HistoryTimeFilter? timeFilter,
    HistoryLocalizations? l10n,
  }) {
    return mapper.map(
      buildOutput(
        selectedDay: selectedDay,
        readings: readings,
        events: events,
        tir: tir,
        isToday: isToday,
        settings: settings,
        timeFilter: timeFilter,
      ),
      l10n: l10n,
    );
  }
}
