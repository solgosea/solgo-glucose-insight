import '../../domain/analysis/analysis_module_code.dart';
import '../../domain/analysis/analysis_snapshot.dart';
import '../../domain/analysis/daily_glucose_summary.dart';
import '../../domain/analysis/period_glucose_summary.dart';
import '../../domain/entities/analysis_results.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/glucose_event.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/glucose/glucose_threshold_context.dart';
import '../../domain/insight/narrative_insight.dart';
import '../../domain/insight/insight_fact_bundle.dart';
import '../../domain/subject/analysis_subject.dart';
import '../../engine/detection/dawn_phenomenon_detector.dart';
import '../../engine/detection/episode_detector.dart';
import '../../engine/statistics/agp_calculator.dart';
import '../../engine/statistics/tir_calculator.dart';
import '../glucose_unit/glucose_unit_format_service.dart';
import 'analysis_session_store.dart';
import '../insight/default_insight_templates.dart';
import '../insight/insight_template_renderer.dart';
import '../insight/insight_template_selector.dart';

typedef AnalysisTirResult = TirResult;
typedef AnalysisAgpSlot = AgpSlot;

class AnalysisFacade {
  final AnalysisSessionStore store;
  final GlucoseUnitFormatService glucoseFormatter;

  const AnalysisFacade(
    this.store, {
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  factory AnalysisFacade.current() =>
      AnalysisFacade(AnalysisSessionStore.instance);

  AnalysisSnapshot? get snapshot => store.snapshot;

  bool get hasSnapshot => store.hasSnapshot;

  AppSettings get settings => store.settings;

  AnalysisSubject get activeSubject => store.activeSubject;

  GlucoseThresholdContext get thresholds =>
      GlucoseThresholdContext.fromSettings(settings);

  List<NarrativeInsight> get insights => store.insights;

  List<NarrativeInsight> insightsFor(AnalysisModuleCode module) =>
      insights.where((i) => i.module == module).toList();

  List<String> insightBodiesFor(AnalysisModuleCode module) =>
      insightsFor(module).map((i) => i.body).toList();

  List<String> localizedInsightBodiesFor(
    AnalysisModuleCode module, {
    String locale = 'en',
  }) {
    const selector = InsightTemplateSelector();
    const renderer = InsightTemplateRenderer();
    return insightsFor(module).map((insight) {
      final template = selector.select(
        InsightFactBundle(
          module: insight.module,
          slot: insight.slot,
          type: insight.type,
          facts: insight.facts,
        ),
        DefaultInsightTemplates.all,
        locale: locale,
        fallbackLocale: 'en',
      );
      if (template == null) return insight.body;
      return renderer.render(template, insight.facts).body;
    }).toList(growable: false);
  }

  DailyGlucoseSummary? get latestDaily {
    final daily = snapshot?.dailySummaries;
    if (daily == null || daily.isEmpty) return null;
    return daily.last;
  }

  List<GlucoseReading> get readings =>
      List.unmodifiable(snapshot?.readings ?? const <GlucoseReading>[]);

  GlucoseReading? get latestReading {
    final rows = readings;
    if (rows.isEmpty) return null;
    return rows.last;
  }

  List<GlucoseReading> readingsForLastHours(int hours, {DateTime? now}) {
    final current = now ?? latestReading?.timestamp ?? DateTime.now();
    final cutoff = current.subtract(Duration(hours: hours));
    return readings
        .where((r) =>
            !r.timestamp.isBefore(cutoff) && !r.timestamp.isAfter(current))
        .toList();
  }

  List<GlucoseReading> readingsForLastDays(int days, {DateTime? now}) {
    final current = now ?? latestReading?.timestamp ?? DateTime.now();
    final cutoff = current.subtract(Duration(days: days));
    return readings
        .where((r) =>
            !r.timestamp.isBefore(cutoff) && !r.timestamp.isAfter(current))
        .toList();
  }

  List<GlucoseReading> readingsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return readings
        .where((r) => !r.timestamp.isBefore(start) && r.timestamp.isBefore(end))
        .toList();
  }

  TirResult tirForReadings(
    List<GlucoseReading> rows, {
    GlucoseThresholdContext? thresholds,
  }) {
    final context = thresholds ?? this.thresholds;
    return TirCalculator.calculate(
      rows,
      veryLow: context.veryLow,
      low: context.low,
      high: context.high,
      veryHigh: context.veryHigh,
    );
  }

  List<AgpSlot> agpForReadings(List<GlucoseReading> rows) {
    if (rows.isEmpty) return const [];
    return AgpCalculator.calculate(rows);
  }

  List<GlucoseEvent> detectEventsForReadings(
    List<GlucoseReading> rows, {
    GlucoseThresholdContext? thresholds,
  }) {
    if (rows.isEmpty) return const [];
    final context = thresholds ?? this.thresholds;
    return EpisodeDetector.detect(
      rows,
      low: context.low,
      high: context.high,
    );
  }

  List<double> hourlyTirForReadings(
    List<GlucoseReading> rows, {
    GlucoseThresholdContext? thresholds,
  }) {
    final context = thresholds ?? this.thresholds;
    final hourTir = List<double>.filled(24, 0);
    for (var h = 0; h < 24; h++) {
      final hourReadings = rows.where((r) => r.timestamp.hour == h).toList();
      if (hourReadings.isEmpty) continue;
      final inRange =
          hourReadings.where((r) => context.isInRange(r.value)).length;
      hourTir[h] = (inRange / hourReadings.length) * 100;
    }
    return hourTir;
  }

  Map<int, double> weekdayTirForLastWeeks(
    int weeks, {
    DateTime? now,
    GlucoseThresholdContext? thresholds,
  }) {
    final context = thresholds ?? this.thresholds;
    final rows = readingsForLastDays(weeks * 7, now: now);
    final byWeekday = <int, List<double>>{};
    for (final r in rows) {
      byWeekday.putIfAbsent(r.timestamp.weekday, () => []).add(r.value);
    }
    return {
      for (final entry in byWeekday.entries)
        entry.key: entry.value.where(context.isInRange).length /
            entry.value.length *
            100,
    };
  }

  bool hasDawnPhenomenon({int days = 14, DateTime? now}) =>
      DawnPhenomenonDetector.isConsistent(readingsForLastDays(days, now: now));

  double dawnRiseAverage({int days = 14, DateTime? now}) =>
      DawnPhenomenonDetector.avgRise(readingsForLastDays(days, now: now));

  double? averageTirForLastDays(int days, {DateTime? now}) {
    final rows = _dailyForLastDays(days, now: now);
    if (rows.isEmpty) return null;
    return rows.map((d) => d.tir).reduce((a, b) => a + b) / rows.length;
  }

  double? averageMeanForLastDays(int days, {DateTime? now}) {
    final rows = _dailyForLastDays(days, now: now);
    if (rows.isEmpty) return null;
    final totalReadings =
        rows.map((d) => d.readingCount).fold<int>(0, (a, b) => a + b);
    if (totalReadings <= 0) return null;
    final weighted =
        rows.map((d) => d.mean * d.readingCount).reduce((a, b) => a + b);
    return weighted / totalReadings;
  }

  double? averageCvForLastDays(int days, {DateTime? now}) {
    final rows = _dailyForLastDays(days, now: now);
    if (rows.isEmpty) return null;
    return rows.map((d) => d.cv).reduce((a, b) => a + b) / rows.length;
  }

  PeriodGlucoseSummary? get mostVariablePeriod {
    final periods =
        snapshot?.periodSummaries.where((p) => p.readingCount > 0).toList();
    if (periods == null || periods.isEmpty) return null;
    periods.sort((a, b) => b.cv.compareTo(a.cv));
    return periods.first;
  }

  Map<DateTime, double> dailyTirMapForLastDays(int days, {DateTime? now}) {
    final rows = _dailyForLastDays(days, now: now);
    return {
      for (final d in rows) DateTime(d.day.year, d.day.month, d.day.day): d.tir,
    };
  }

  GlucotypeResult? glucotypeFromDaily({int days = 14, DateTime? now}) {
    final rows = _dailyForLastDays(days, now: now);
    if (rows.isEmpty) return null;
    final dailyPeakAvg =
        rows.map((d) => d.maxValue).reduce((a, b) => a + b) / rows.length;
    final cv = rows.map((d) => d.cv).reduce((a, b) => a + b) / rows.length;

    final level = dailyPeakAvg < 8.5 && cv < 25
        ? GlucotypeLevel.low
        : dailyPeakAvg > 10.5 || cv > 36
            ? GlucotypeLevel.severe
            : GlucotypeLevel.moderate;

    return GlucotypeResult(
      level: level,
      dailyPeakAvg: dailyPeakAvg,
      cv: cv,
      basedOn: '$days days',
    );
  }

  PersonalBaseline? baselineFromDaily({int days = 60, DateTime? now}) {
    final rows = _dailyForLastDays(days, now: now);
    if (rows.length < 5) return null;

    final tirs = rows.map((d) => d.tir).toList()..sort();
    final peaks = rows.map((d) => d.maxValue).toList()..sort();
    final cvs = rows.map((d) => d.cv).toList()..sort();
    final firstReadings = rows.map((d) => d.firstReadingValue).toList()..sort();
    final means = rows.map((d) => d.mean).toList()..sort();

    return PersonalBaseline(
      tirLow: _percentile(tirs, 25),
      tirHigh: _percentile(tirs, 75),
      peakLow: _percentile(peaks, 25),
      peakHigh: _percentile(peaks, 75),
      cvLow: _percentile(cvs, 25),
      cvHigh: _percentile(cvs, 75),
      fastingLow: _percentile(firstReadings, 25),
      fastingHigh: _percentile(firstReadings, 75),
      averageMeanLow: _percentile(means, 25),
      averageMeanHigh: _percentile(means, 75),
      updatedAt: snapshot?.generatedAt ?? DateTime.now(),
      daysUsed: rows.length,
    );
  }

  List<GlucoseEvent> eventsForLastDays(int days, {DateTime? now}) {
    final current = now ?? latestReading?.timestamp ?? DateTime.now();
    final from = current.subtract(Duration(days: days));
    return _eventsBetween(from, current);
  }

  List<GlucoseEvent> eventsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    return _eventsBetween(start, start.add(const Duration(days: 1)));
  }

  String? compactDailySummary() {
    final latest = latestDaily;
    if (latest == null) return null;
    final mean = glucoseFormatter.value(latest.mean, settings.unit);
    return 'TIR ${latest.tir.toStringAsFixed(0)}%, mean ${mean.fullLabel}, CV ${latest.cv.toStringAsFixed(0)}%.';
  }

  String? compactPatternSummary() {
    final period = mostVariablePeriod;
    if (period == null) return null;
    return '${period.label} is the most variable window, CV ${period.cv.toStringAsFixed(0)}%.';
  }

  List<GlucoseEvent> _eventsBetween(DateTime from, DateTime to) {
    final events = snapshot?.events ?? const <GlucoseEvent>[];
    return events
        .where((e) => !e.time.isBefore(from) && e.time.isBefore(to))
        .toList();
  }

  List<DailyGlucoseSummary> _dailyForLastDays(int days, {DateTime? now}) {
    final rows = snapshot?.dailySummaries;
    if (rows == null || rows.isEmpty) return const [];
    final anchor = now ?? latestReading?.timestamp ?? DateTime.now();
    final cutoff = anchor.subtract(Duration(days: days));
    return rows.where((d) => !d.day.isBefore(cutoff)).toList();
  }

  double _percentile(List<double> sorted, int percentile) {
    if (sorted.isEmpty) return 0;
    final index = ((percentile / 100) * (sorted.length - 1)).round();
    final clamped = index.clamp(0, sorted.length - 1).toInt();
    return sorted[clamped];
  }
}
