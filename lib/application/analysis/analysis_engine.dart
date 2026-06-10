import '../../data/local/glucose_database.dart';
import '../../domain/analysis/analysis_context.dart';
import '../../domain/analysis/analysis_module_code.dart';
import '../../domain/analysis/analysis_snapshot.dart';
import '../../domain/analysis/analysis_window.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/subject/glucose_subject.dart';
import '../../engine/detection/glucose_gap_detector.dart';
import '../../engine/statistics/agp_calculator.dart';
import '../../engine/statistics/tir_calculator.dart';
import 'modules/daily_summary_module.dart';
import 'modules/event_analysis_module.dart';
import 'modules/period_summary_module.dart';

class AnalysisEngine {
  final GlucoseDatabase database;
  final DailySummaryModule dailySummaryModule;
  final PeriodSummaryModule periodSummaryModule;
  final EventAnalysisModule eventAnalysisModule;

  const AnalysisEngine({
    required this.database,
    this.dailySummaryModule = const DailySummaryModule(),
    this.periodSummaryModule = const PeriodSummaryModule(),
    this.eventAnalysisModule = const EventAnalysisModule(),
  });

  Future<AnalysisSnapshot> runWindow({
    required AppSettings settings,
    AnalysisWindow? window,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final targetWindow = window ?? await _defaultWindow(subjectId);
    final readings = await database.range(
      targetWindow.start,
      targetWindow.end,
      subjectId: subjectId,
    );
    final context = AnalysisContext(
      window: targetWindow,
      settings: settings,
      readings: readings,
    );

    final daily = await dailySummaryModule.run(context);
    final periods = await periodSummaryModule.run(context);
    final events = await eventAnalysisModule.run(context);
    final gaps = GlucoseGapDetector.detect(readings, source: 'canonical');

    await database.upsertDailyStats(daily, subjectId: subjectId);
    await database.upsertPeriodStats(
      periods,
      windowKey: targetWindow.label,
      subjectId: subjectId,
    );
    await database.upsertEvents(events, subjectId: subjectId);
    await database.upsertGaps(gaps, subjectId: subjectId);
    await _persistAgp(context, subjectId: subjectId);
    await _persistPatternSnapshot(context, events.length, subjectId: subjectId);

    return AnalysisSnapshot(
      generatedAt: DateTime.now(),
      windowStart: targetWindow.start,
      windowEnd: targetWindow.end,
      readings: readings,
      dailySummaries: daily,
      periodSummaries: periods,
      events: events,
    );
  }

  Future<AnalysisWindow> _defaultWindow(String subjectId) async {
    final latest = await database.latest(subjectId: subjectId);
    final anchor =
        latest?.timestamp.add(const Duration(minutes: 1)) ?? DateTime.now();
    return AnalysisWindow.lastDays(14, now: anchor);
  }

  Future<void> _persistAgp(
    AnalysisContext context, {
    required String subjectId,
  }) async {
    if (context.readings.length < 24) return;
    final slots = AgpCalculator.calculate(context.readings);
    await database.putJsonSnapshot(
      table: GlucoseDatabase.agpSnapshotsTable,
      key: 'agp_${context.window.label}',
      start: context.window.start,
      end: context.window.end,
      subjectId: subjectId,
      payload: {
        'slots':
            slots
                .map(
                  (s) => {
                    'minuteOfDay': s.minuteOfDay,
                    'p10': s.p10,
                    'p25': s.p25,
                    'p50': s.p50,
                    'p75': s.p75,
                    'p90': s.p90,
                  },
                )
                .toList(),
      },
    );
  }

  Future<void> _persistPatternSnapshot(
    AnalysisContext context,
    int eventCount, {
    required String subjectId,
  }) async {
    final tir = TirCalculator.calculate(
      context.readings,
      low: context.settings.lowThreshold,
      high: context.settings.highThreshold,
      veryHigh: context.settings.veryHighThreshold,
    );
    await database.putJsonSnapshot(
      table: GlucoseDatabase.patternSnapshotsTable,
      key: 'patterns_${context.window.label}',
      moduleCode: AnalysisModuleCode.insights.code,
      start: context.window.start,
      end: context.window.end,
      subjectId: subjectId,
      payload: {
        'readingCount': context.readings.length,
        'tir': tir.tir,
        'cv': tir.cv,
        'mean': tir.mean,
        'eventCount': eventCount,
      },
    );
  }
}
