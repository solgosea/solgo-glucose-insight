import '../../domain/analysis/analysis_module_code.dart';
import '../../domain/analysis/analysis_snapshot.dart';
import '../../domain/analysis/daily_glucose_summary.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/glucose_event.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/glucose/glucose_threshold_context.dart';
import '../../domain/insight/insight_fact_bundle.dart';
import '../../domain/insight/insight_slot_code.dart';
import '../../domain/insight/insight_type_code.dart';
import '../../engine/detection/dawn_phenomenon_detector.dart';
import '../../engine/statistics/tir_calculator.dart';
import '../glucose_unit/glucose_unit_format_service.dart';
import '../glucose_unit/glucose_template_value_adapter.dart';

class InsightFactBuilder {
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseTemplateValueAdapter templateValueAdapter;

  const InsightFactBuilder({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.templateValueAdapter = const GlucoseTemplateValueAdapter(),
  });

  List<InsightFactBundle> build(
    AnalysisSnapshot snapshot,
    AppSettings settings,
  ) {
    final now = _anchor(snapshot);
    final readings14 = _readingsForLastDays(snapshot.readings, 14, now);
    final readings7 = _readingsForLastDays(snapshot.readings, 7, now);
    final previous7 = _readingsForLastDays(
      snapshot.readings,
      7,
      now.subtract(const Duration(days: 7)),
    );
    final thresholds = GlucoseThresholdContext.fromSettings(settings);
    final tir7 = _tir(readings7, thresholds);
    final prevTir7 = _tir(previous7, thresholds);
    final periods = _periodStats(readings14, thresholds);
    final dawn = _dawn(readings14);
    final mostVolatile = _mostVolatile(periods);
    final mostStable = _mostStable(periods);
    final weekdayGap = _weekdayGap(snapshot.readings, now, thresholds);
    final events7 = _eventsForLastDays(snapshot.events, 7, now);
    final highEpisodes = events7
        .where((event) => event.type == GlucoseEventType.highEpisode)
        .toList();

    final bundles = <InsightFactBundle>[
      _dailyBrief(snapshot, now, settings),
      _weeklyReview(snapshot, now, tir7, prevTir7, highEpisodes, settings),
    ];

    if (dawn.observedDays > 0) {
      bundles.add(_dawnBundle(dawn, settings));
    }
    if (mostVolatile != null) {
      bundles.add(_periodBundle(
        mostVolatile,
        InsightTypeCode.volatilePeriod,
        settings: settings,
        priority: 40,
      ));
    }
    if (mostStable != null) {
      bundles.add(_periodBundle(
        mostStable,
        InsightTypeCode.stablePeriod,
        settings: settings,
        priority: 50,
      ));
    }
    if (weekdayGap != null) {
      bundles.add(_weekdayGapBundle(weekdayGap));
    }
    if (bundles.where((b) => b.slot == InsightSlotCode.patternCard).isEmpty) {
      bundles.add(
        InsightFactBundle(
          module: AnalysisModuleCode.insights,
          slot: InsightSlotCode.patternCard,
          type: InsightTypeCode.notEnoughPatternData,
          priority: 100,
          facts: {'readingCount14': readings14.length},
        ),
      );
    }

    return bundles;
  }

  InsightFactBundle _dailyBrief(
    AnalysisSnapshot snapshot,
    DateTime now,
    AppSettings settings,
  ) {
    final targetDay = _latestCompleteDay(snapshot.dailySummaries, now);
    if (targetDay == null) {
      return const InsightFactBundle(
        module: AnalysisModuleCode.insights,
        slot: InsightSlotCode.dailyBrief,
        type: InsightTypeCode.dailyNotEnoughData,
        priority: 10,
        facts: {},
      );
    }

    final dayReadings = _readingsForDay(snapshot.readings, targetDay.day);
    final averageTir14 = _averageDailyTir(snapshot.dailySummaries, now, 14);
    final averageCv14 = _averageDailyCv(snapshot.dailySummaries, now, 14);
    final thresholds = GlucoseThresholdContext.fromSettings(settings);
    final evening = _eveningPeak(dayReadings, thresholds);
    final night = _nightRange(dayReadings);
    final displayFacts = templateValueAdapter.displayFactsFor(settings);
    final highThreshold =
        glucoseFormatter.value(settings.highThreshold, settings.unit).value;
    final facts = <String, Object?>{
      ...displayFacts,
      'dayLabel': _dayLabel(targetDay.day, now),
      'tir': targetDay.tir.toStringAsFixed(0),
      'tirDeltaPhrase': _deltaPhrase(targetDay.tir - averageTir14),
      'avgTir14': averageTir14.toStringAsFixed(0),
      'cv': targetDay.cv.toStringAsFixed(0),
      'cvDeltaPhrase': _cvPhrase(targetDay.cv - averageCv14),
      'avgCv14': averageCv14.toStringAsFixed(0),
      'observedDays14': _observedDays(snapshot.dailySummaries, now, 14),
    };
    if (evening != null) {
      final eveningValue = glucoseFormatter.value(evening.value, settings.unit);
      facts.addAll({
        'eveningPeakTime': _formatTime(evening.time),
        'eveningPeakValue': eveningValue.valueLabel,
        'eveningAboveTarget':
            (eveningValue.value - highThreshold).toStringAsFixed(1),
        'eveningHighMinutes': evening.highMinutes,
      });
    }
    if (night != null) {
      facts['nightRange'] =
          glucoseFormatter.range(night.min, night.max, settings.unit).fullLabel;
    }

    return InsightFactBundle(
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.dailyBrief,
      type: InsightTypeCode.dailyCompleteDay,
      priority: 10,
      facts: facts,
    );
  }

  InsightFactBundle _weeklyReview(
    AnalysisSnapshot snapshot,
    DateTime now,
    TirResult tir7,
    TirResult prevTir7,
    List<GlucoseEvent> highEpisodes,
    AppSettings settings,
  ) {
    final weekRange = _weekRange(now);
    final delta = tir7.tir - prevTir7.tir;
    final bestDays = _bestDays(snapshot.dailySummaries, now);
    final longest = _longestHigh(highEpisodes);

    final facts = <String, Object?>{
      ...templateValueAdapter.displayFactsFor(settings),
      'weekRange': _formatWeekRange(weekRange.start, weekRange.end),
      'tir7': tir7.tir.toStringAsFixed(0),
      'tirDeltaPhrase': _weekDeltaPhrase(delta),
      'prevTir7': prevTir7.tir.toStringAsFixed(0),
      'cv7': tir7.cv.toStringAsFixed(0),
      'readingCount7': tir7.readingCount,
      'bestDayShort': bestDays.isEmpty ? '--' : bestDays.first,
      'longestHighValue':
          longest == null ? '--' : _durationText(longest.durationMinutes),
      'longestHighLabel': longest == null
          ? 'Longest high'
          : 'Longest high - ${_weekdayShort(longest.time.weekday)}',
      'hasLongestHigh': longest != null,
    };
    if (bestDays.isNotEmpty) {
      facts.addAll({
        'bestDayNames': _joinDayNames(bestDays),
        'bestDayVerb': bestDays.length == 1 ? 'was' : 'were',
        'bestDayNoun': bestDays.length == 1 ? 'day' : 'days',
      });
    }
    if (longest != null) {
      facts.addAll({
        'longestHighDay': _weekdayShort(longest.time.weekday),
        'longestHighStart': _formatTime(longest.time),
        'longestHighEnd': _formatTime(longest.endTime ?? longest.time),
        'longestHighPeak': glucoseFormatter
            .value(longest.peakOrNadir ?? longest.value, settings.unit)
            .fullLabel,
      });
    }

    return InsightFactBundle(
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.weeklyReview,
      type: InsightTypeCode.weeklyReview,
      priority: 20,
      facts: facts,
    );
  }

  InsightFactBundle _dawnBundle(_DawnResult dawn, AppSettings settings) {
    final consistent = dawn.consistent;
    final riseThreshold = glucoseFormatter.value(
      DawnPhenomenonDetector.significantRiseMmol,
      settings.unit,
    );
    final facts = <String, Object?>{
      ...templateValueAdapter.displayFactsFor(settings),
      'dawnTitle':
          consistent ? 'Dawn phenomenon detected' : 'Pre-dawn rise check',
      'windowLabel': DawnPhenomenonDetector.windowLabel,
      'observedMornings': dawn.observedDays,
      'significantDays': dawn.significantDays,
      'riseThreshold': riseThreshold.valueLabel,
    };
    if (consistent) {
      facts['averageRise'] =
          glucoseFormatter.value(dawn.averageRise, settings.unit).valueLabel;
    }
    return InsightFactBundle(
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: InsightTypeCode.dawnPattern,
      priority: 30,
      facts: facts,
    );
  }

  InsightFactBundle _periodBundle(
    _PeriodResult period,
    InsightTypeCode type, {
    required AppSettings settings,
    required int priority,
  }) {
    return InsightFactBundle(
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: type,
      priority: priority,
      facts: {
        ...templateValueAdapter.displayFactsFor(settings),
        'periodLabel': period.label,
        'periodCv': period.cv.toStringAsFixed(0),
        'periodTir': period.tir.toStringAsFixed(0),
        'periodMean':
            glucoseFormatter.value(period.mean, settings.unit).valueLabel,
        'periodReadingCount': period.readingCount,
      },
    );
  }

  InsightFactBundle _weekdayGapBundle(_WeekdayGapResult gap) {
    return InsightFactBundle(
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.patternCard,
      type: InsightTypeCode.weekdayGap,
      priority: 60,
      facts: {
        'weekdayGapTitle': gap.weekendLower
            ? 'Weekends show lower TIR'
            : 'Weekends show higher TIR',
        'weekendTir': gap.weekendTir.toStringAsFixed(0),
        'weekdayGapDelta': gap.deltaAbs.toStringAsFixed(0),
        'weekdayGapDirection': gap.weekendLower ? 'below' : 'above',
        'weekdayTir': gap.weekdayTir.toStringAsFixed(0),
        'weekdayGapDays': gap.weekendDays + gap.weekdayDays,
      },
    );
  }

  DateTime _anchor(AnalysisSnapshot snapshot) {
    if (snapshot.readings.isNotEmpty) return snapshot.readings.last.timestamp;
    return snapshot.windowEnd;
  }

  List<GlucoseReading> _readingsForLastDays(
    List<GlucoseReading> readings,
    int days,
    DateTime now,
  ) {
    final cutoff = now.subtract(Duration(days: days));
    return readings
        .where(
            (r) => !r.timestamp.isBefore(cutoff) && !r.timestamp.isAfter(now))
        .toList();
  }

  List<GlucoseReading> _readingsForDay(
    List<GlucoseReading> readings,
    DateTime day,
  ) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return readings
        .where((r) => !r.timestamp.isBefore(start) && r.timestamp.isBefore(end))
        .toList();
  }

  List<GlucoseEvent> _eventsForLastDays(
    List<GlucoseEvent> events,
    int days,
    DateTime now,
  ) {
    final cutoff = now.subtract(Duration(days: days));
    return events
        .where((e) => !e.time.isBefore(cutoff) && !e.time.isAfter(now))
        .toList();
  }

  _DawnResult _dawn(List<GlucoseReading> readings) {
    final rises = DawnPhenomenonDetector.detectDailyRises(readings);
    if (rises.isEmpty) return const _DawnResult(false, 0, 0, 0);
    final significant = rises
        .where((rise) => rise >= DawnPhenomenonDetector.significantRiseMmol)
        .length;
    final required = (rises.length * 0.65).ceil().clamp(2, 10).toInt();
    final avg = rises.reduce((a, b) => a + b) / rises.length;
    return _DawnResult(significant >= required, avg, significant, rises.length);
  }

  List<_PeriodResult> _periodStats(
    List<GlucoseReading> readings,
    GlucoseThresholdContext thresholds,
  ) {
    const periods = [
      _PeriodDefinition('Night', 0, 6),
      _PeriodDefinition('Morning', 6, 12),
      _PeriodDefinition('Afternoon', 12, 18),
      _PeriodDefinition('Evening', 18, 24),
    ];
    final result = <_PeriodResult>[];
    for (final period in periods) {
      final rows = readings
          .where((reading) =>
              reading.timestamp.hour >= period.startHour &&
              reading.timestamp.hour < period.endHour)
          .toList();
      if (rows.length < 12) continue;
      final tir = _tir(rows, thresholds);
      result.add(_PeriodResult(
        period.label,
        rows.length,
        tir.tir,
        tir.mean,
        tir.cv,
      ));
    }
    return result;
  }

  _PeriodResult? _mostVolatile(List<_PeriodResult> periods) {
    if (periods.isEmpty) return null;
    final rows = [...periods]..sort((a, b) => b.cv.compareTo(a.cv));
    return rows.first;
  }

  _PeriodResult? _mostStable(List<_PeriodResult> periods) {
    if (periods.isEmpty) return null;
    final rows = [...periods]
      ..sort((a, b) => (b.tir - b.cv).compareTo(a.tir - a.cv));
    return rows.first;
  }

  _WeekdayGapResult? _weekdayGap(
    List<GlucoseReading> readings,
    DateTime now,
    GlucoseThresholdContext thresholds,
  ) {
    final rows = <({DateTime day, double tir})>[];
    for (var i = 1; i <= 90; i++) {
      final day = now.subtract(Duration(days: i));
      final dayReadings = _readingsForDay(readings, day);
      if (dayReadings.length < 12) continue;
      rows.add((day: day, tir: _tir(dayReadings, thresholds).tir));
    }
    if (rows.length < 7) return null;
    final weekend =
        rows.where((row) => row.day.weekday >= DateTime.saturday).toList();
    final weekdays =
        rows.where((row) => row.day.weekday < DateTime.saturday).toList();
    if (weekend.length < 2 || weekdays.length < 5) return null;
    final weekendTir = _average(weekend.map((row) => row.tir));
    final weekdayTir = _average(weekdays.map((row) => row.tir));
    final delta = weekendTir - weekdayTir;
    if (delta.abs() < 3) return null;
    return _WeekdayGapResult(
      weekendTir,
      weekdayTir,
      delta.abs(),
      delta < 0,
      weekend.length,
      weekdays.length,
    );
  }

  DailyGlucoseSummary? _latestCompleteDay(
    List<DailyGlucoseSummary> daily,
    DateTime now,
  ) {
    if (daily.isEmpty) return null;
    final today = DateTime(now.year, now.month, now.day);
    final complete = daily
        .where((summary) => summary.day.isBefore(today))
        .toList()
      ..sort((a, b) => b.day.compareTo(a.day));
    return complete.isNotEmpty ? complete.first : daily.last;
  }

  double _averageDailyTir(
    List<DailyGlucoseSummary> daily,
    DateTime now,
    int days,
  ) {
    return _average(
        _recentDaily(daily, now, days).map((summary) => summary.tir));
  }

  double _averageDailyCv(
    List<DailyGlucoseSummary> daily,
    DateTime now,
    int days,
  ) {
    return _average(
        _recentDaily(daily, now, days).map((summary) => summary.cv));
  }

  List<DailyGlucoseSummary> _recentDaily(
    List<DailyGlucoseSummary> daily,
    DateTime now,
    int days,
  ) {
    final cutoff =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: days));
    return daily.where((summary) => !summary.day.isBefore(cutoff)).toList();
  }

  ({DateTime time, double value, double aboveTarget, int highMinutes})?
      _eveningPeak(
    List<GlucoseReading> readings,
    GlucoseThresholdContext thresholds,
  ) {
    final evening = readings
        .where((reading) =>
            reading.timestamp.hour >= 18 && reading.timestamp.hour < 24)
        .toList();
    if (evening.isEmpty) return null;
    final peak = evening.reduce((a, b) => a.value > b.value ? a : b);
    if (peak.value <= thresholds.high) return null;
    final sampleMinutes = _sampleMinutes(evening);
    final highMinutes =
        evening.where((reading) => reading.value > thresholds.high).length *
            sampleMinutes;
    return (
      time: peak.timestamp,
      value: peak.value,
      aboveTarget: peak.value - thresholds.high,
      highMinutes: highMinutes,
    );
  }

  ({double min, double max})? _nightRange(List<GlucoseReading> readings) {
    final night = readings
        .where((reading) =>
            reading.timestamp.hour >= 0 && reading.timestamp.hour < 6)
        .toList();
    if (night.isEmpty) return null;
    final min =
        night.map((reading) => reading.value).reduce((a, b) => a < b ? a : b);
    final max =
        night.map((reading) => reading.value).reduce((a, b) => a > b ? a : b);
    return (min: min, max: max);
  }

  int _sampleMinutes(List<GlucoseReading> readings) {
    if (readings.length < 2) return 5;
    final ordered = [...readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final deltas = <int>[];
    for (var i = 1; i < ordered.length; i++) {
      final minutes =
          ordered[i].timestamp.difference(ordered[i - 1].timestamp).inMinutes;
      if (minutes > 0 && minutes <= 30) deltas.add(minutes);
    }
    if (deltas.isEmpty) return 5;
    deltas.sort();
    return deltas[deltas.length ~/ 2];
  }

  List<String> _bestDays(List<DailyGlucoseSummary> daily, DateTime now) {
    final cutoff = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 7));
    final recent = daily
        .where((summary) => !summary.day.isBefore(cutoff))
        .toList()
      ..sort((a, b) => b.tir.compareTo(a.tir));
    return recent
        .take(2)
        .map<String>((summary) => _weekdayShort(summary.day.weekday))
        .toList();
  }

  GlucoseEvent? _longestHigh(List<GlucoseEvent> highEpisodes) {
    if (highEpisodes.isEmpty) return null;
    return highEpisodes.reduce(
      (a, b) => a.durationMinutes > b.durationMinutes ? a : b,
    );
  }

  ({DateTime start, DateTime end}) _weekRange(DateTime now) {
    final end = now.subtract(const Duration(days: 1));
    return (start: end.subtract(const Duration(days: 6)), end: end);
  }

  int _observedDays(List<DailyGlucoseSummary> daily, DateTime now, int days) {
    return _recentDaily(daily, now, days).length;
  }

  double _average(Iterable<double> values) {
    final rows = values.toList();
    if (rows.isEmpty) return 0;
    return rows.reduce((a, b) => a + b) / rows.length;
  }

  TirResult _tir(
    List<GlucoseReading> readings,
    GlucoseThresholdContext thresholds,
  ) {
    return TirCalculator.calculate(
      readings,
      veryLow: thresholds.veryLow,
      low: thresholds.low,
      high: thresholds.high,
      veryHigh: thresholds.veryHigh,
    );
  }

  String _dayLabel(DateTime day, DateTime now) {
    return _formatHeaderDate(day);
  }

  String _deltaPhrase(double delta) {
    if (delta.abs() < 0.5) return 'matching';
    final magnitude = delta.abs().toStringAsFixed(0);
    return delta > 0 ? '${magnitude}pp above' : '${magnitude}pp below';
  }

  String _cvPhrase(double delta) {
    if (delta.abs() < 1) return 'close to';
    final magnitude = delta.abs().toStringAsFixed(0);
    return delta > 0 ? '${magnitude}pp above' : '${magnitude}pp below';
  }

  String _weekDeltaPhrase(double delta) {
    if (delta.abs() < 0.5) return 'unchanged from';
    return delta > 0
        ? 'up ${delta.abs().toStringAsFixed(0)}pp from'
        : 'down ${delta.abs().toStringAsFixed(0)}pp from';
  }

  String _formatHeaderDate(DateTime date) {
    return '${_monthShort(date.month)} ${date.day}, ${date.year}';
  }

  String _formatWeekRange(DateTime start, DateTime end) {
    final startMonth = _monthShort(start.month).toUpperCase();
    final endMonth = _monthShort(end.month).toUpperCase();
    if (start.month == end.month) return '$startMonth ${start.day}-${end.day}';
    return '$startMonth ${start.day} - $endMonth ${end.day}';
  }

  String _joinDayNames(List<String> days) {
    if (days.length <= 1) return days.join();
    if (days.length == 2) return '${days.first} and ${days.last}';
    return '${days.take(days.length - 1).join(', ')}, and ${days.last}';
  }

  String _weekdayShort(int weekday) =>
      const ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][weekday];

  String _monthShort(int month) {
    return switch (month) {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mar',
      4 => 'Apr',
      5 => 'May',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Oct',
      11 => 'Nov',
      _ => 'Dec',
    };
  }

  String _formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _durationText(int minutes) {
    if (minutes <= 0) return '--';
    if (minutes < 60) return '${minutes}m';
    return '${(minutes / 60).toStringAsFixed(1)}h';
  }
}

class _DawnResult {
  final bool consistent;
  final double averageRise;
  final int significantDays;
  final int observedDays;

  const _DawnResult(
    this.consistent,
    this.averageRise,
    this.significantDays,
    this.observedDays,
  );
}

class _PeriodDefinition {
  final String label;
  final int startHour;
  final int endHour;

  const _PeriodDefinition(this.label, this.startHour, this.endHour);
}

class _PeriodResult {
  final String label;
  final int readingCount;
  final double tir;
  final double mean;
  final double cv;

  const _PeriodResult(
    this.label,
    this.readingCount,
    this.tir,
    this.mean,
    this.cv,
  );
}

class _WeekdayGapResult {
  final double weekendTir;
  final double weekdayTir;
  final double deltaAbs;
  final bool weekendLower;
  final int weekendDays;
  final int weekdayDays;

  const _WeekdayGapResult(
    this.weekendTir,
    this.weekdayTir,
    this.deltaAbs,
    this.weekendLower,
    this.weekendDays,
    this.weekdayDays,
  );
}
