import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../shared/episode_context_card.dart';
import '../shared/episode_pattern_card.dart';
import '../shared/episode_similar_card.dart';

import '../analyzers/episode_context_analyzer.dart';
import '../analyzers/episode_detail_formatters.dart';
import '../analyzers/episode_focus_selector.dart';
import '../analyzers/episode_window_analyzer.dart';
import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import '../models/episode_severity_view_model.dart';

class EpisodeDetailViewModelMapper {
  final EpisodeFocusSelector focusSelector;
  final EpisodeWindowAnalyzer windowAnalyzer;
  final EpisodeContextAnalyzer contextAnalyzer;
  final GlucoseUnitFormatService glucoseFormatter;

  const EpisodeDetailViewModelMapper({
    this.focusSelector = const EpisodeFocusSelector(),
    this.windowAnalyzer = const EpisodeWindowAnalyzer(),
    this.contextAnalyzer = const EpisodeContextAnalyzer(),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  EpisodeDetailViewModel map({
    required EpisodeKind kind,
    AnalysisFacade? facade,
  }) {
    final analysis = facade ?? AnalysisFacade.current();
    final settings = analysis.settings;
    final unit = settings.unit;
    final allReadings = analysis.readingsForLastDays(90);
    final eventType =
        kind == EpisodeKind.high
            ? GlucoseEventType.highEpisode
            : GlucoseEventType.lowEpisode;
    final detected =
        analysis.eventsForLastDays(90).isNotEmpty
            ? analysis.eventsForLastDays(90)
            : analysis.detectEventsForReadings(allReadings);
    final events =
        detected.where((event) => event.type == eventType).toList()
          ..sort((a, b) => a.time.compareTo(b.time));
    final recentEvents = _eventsInLastDays(
      events,
      30,
      analysis.latestReading?.timestamp,
    );
    final focus = focusSelector.latestOfType(
      recentEvents.isNotEmpty ? recentEvents : events,
      type: eventType,
    );

    if (focus == null) {
      return _empty(kind);
    }

    final high = kind == EpisodeKind.high;
    final themeColor = high ? AppColors.rose : AppColors.blue;
    final endTime =
        focus.endTime ??
        focus.time.add(Duration(minutes: math.max(focus.durationMinutes, 0)));
    final duration = math.max(focus.durationMinutes, 0);
    final window = windowAnalyzer.analyze(
      event: focus,
      allReadings: allReadings,
      high: high,
    );
    final extreme = _extremeValue(focus, window.extremeReading, high);
    final rate = _episodeRate(focus, window.leadUpSlope, high);
    final recoveryRate = _recoveryRate(
      extreme: extreme,
      duration: duration,
      high: high,
    );
    final area = _episodeArea(focus, extreme, duration, high, settings);

    return EpisodeDetailViewModel(
      kind: kind,
      statusTime: EpisodeDetailFormatters.hm(focus.time),
      title: high ? 'High Episode' : 'Low Episode',
      subtitle: EpisodeDetailFormatters.headerDate(focus.time),
      hero: EpisodeHeroViewModel(
        valueLabel: high ? 'Peak Value' : 'Nadir Value',
        valueText: glucoseFormatter.value(extreme, unit).valueLabel,
        valueUnit: glucoseFormatter.unitLabel(unit),
        valueColor: themeColor,
        durationText: '$duration min',
        durationRange: EpisodeDetailFormatters.range(focus.time, endTime),
        onsetRateLabel: high ? 'Onset rate' : 'Descent rate',
        onsetRateText: EpisodeDetailFormatters.rate(
          rate,
          unit: unit,
          forcePositive: high && rate >= 0,
        ),
        onsetRateColor: high ? AppColors.amber : AppColors.blue,
        recoveryRateText: EpisodeDetailFormatters.rate(
          recoveryRate,
          unit: unit,
          forcePositive: !high && recoveryRate >= 0,
        ),
        areaLabel: high ? 'Area above target' : 'Area below target',
        areaText: glucoseFormatter.area(area.abs(), unit).fullLabel,
        areaColor: themeColor,
        heroBg: themeColor.withOpacity(0.06),
        heroBorder: themeColor.withOpacity(0.22),
        showNocturnalBadge: !high && focus.isNocturnal,
      ),
      chart: EpisodeChartViewModel(
        readings: window.readings,
        unit: unit,
        lowThreshold: settings.lowThreshold,
        highThreshold: settings.highThreshold,
        onsetTime: focus.time,
        peakOrNadirTime: window.extremeReading?.timestamp ?? focus.time,
        recoveryTime: endTime,
        themeColor: themeColor,
        episode: ChartEpisode(
          start: focus.time,
          end: endTime,
          color: themeColor,
        ),
      ),
      contextRows: _contextRows(
        focus: focus,
        window: window,
        allReadings: allReadings,
        high: high,
        unit: unit,
      ),
      pattern:
          high
              ? _highPattern(events, analysis.latestReading?.timestamp)
              : _lowPattern(events, analysis.latestReading?.timestamp),
      severity: high ? null : _lowSeverity(extreme, settings),
      similarHeader:
          high
              ? 'Similar Episodes (Past 30 Days)'
              : 'Similar Episodes (Past 90 Days)',
      similarCards: _similarCards(
        current: focus,
        events: high ? recentEvents : events,
        high: high,
        themeColor: themeColor,
        unit: unit,
      ),
      disclaimer:
          high
              ? 'This is observational CGM analysis only and is not medical advice. Consult your healthcare provider for clinical decisions.'
              : 'Low glucose episodes require clinical interpretation. This is observational CGM analysis only and is not medical advice.',
      emptyText: '',
    );
  }

  EpisodeDetailViewModel _empty(EpisodeKind kind) {
    final high = kind == EpisodeKind.high;
    return EpisodeDetailViewModel(
      kind: kind,
      statusTime: high ? '09:52' : '03:24',
      title: high ? 'High Episode' : 'Low Episode',
      subtitle: high ? 'No recent high episode' : 'No recent low episode',
      hero: null,
      chart: null,
      contextRows: const [],
      pattern: null,
      severity: null,
      similarHeader: '',
      similarCards: const [],
      disclaimer: '',
      emptyText:
          high
              ? 'No high glucose episodes detected in the last 30 days.'
              : 'No low glucose episodes detected in the last 30 days.',
    );
  }

  List<EpisodeContextRow> _contextRows({
    required GlucoseEvent focus,
    required EpisodeWindowAnalysis window,
    required List<GlucoseReading> allReadings,
    required bool high,
    required GlucoseUnit unit,
  }) {
    final baseline =
        window.baselineLow == null || window.baselineHigh == null
            ? 'Baseline range unavailable; not enough readings before onset'
            : high
            ? 'Pre-onset baseline ${glucoseFormatter.range(window.baselineLow!, window.baselineHigh!, unit).fullLabel}'
            : 'Pre-episode range ${glucoseFormatter.range(window.baselineLow!, window.baselineHigh!, unit).fullLabel}';
    final typicalSlope = contextAnalyzer.typicalSlopeForHours(
      allReadings,
      startHour: high ? 4 : 0,
      endHour: high ? 8 : 6,
    );
    final slopeText = _slopeContextText(
      slope: window.leadUpSlope,
      typicalSlope: typicalSlope,
      high: high,
      unit: unit,
    );
    final variability = contextAnalyzer.variabilityForHour(
      allReadings,
      focus.time.hour,
    );
    final variabilityText =
        variability == null
            ? 'Time-window variability unavailable; not enough historical readings'
            : '${variability.label} window (${variability.windowText}) CV ${variability.cv.toStringAsFixed(0)}%, rank ${variability.rank}/${variability.total} by variability';

    return [
      EpisodeContextRow(
        icon: 'B',
        timeWindow: EpisodeDetailFormatters.range(
          window.start,
          window.preMidpoint,
        ),
        description: baseline,
        contextTag: '~2h before',
      ),
      EpisodeContextRow(
        icon: 'T',
        timeWindow: EpisodeDetailFormatters.range(
          window.preMidpoint,
          focus.time,
        ),
        description: slopeText,
        contextTag: 'lead-up',
      ),
      EpisodeContextRow(
        icon: 'C',
        timeWindow: variability?.windowText ?? '${focus.time.hour}:00',
        description: variabilityText,
        contextTag: 'time context',
      ),
    ];
  }

  String _slopeContextText({
    required double? slope,
    required double? typicalSlope,
    required bool high,
    required GlucoseUnit unit,
  }) {
    if (slope == null) {
      return 'Lead-up readings limited; slope cannot be estimated from this window';
    }
    final slopePart =
        high
            ? 'Lead-up rise ${EpisodeDetailFormatters.rate(slope, unit: unit, forcePositive: slope >= 0)}'
            : 'Lead-up descent ${EpisodeDetailFormatters.rate(slope, unit: unit)}';
    if (typicalSlope == null) {
      return '$slopePart; historical comparison unavailable';
    }
    final diff = slope - typicalSlope;
    final direction =
        diff.abs() < 0.01
            ? 'near'
            : diff > 0
            ? 'above'
            : 'below';
    return '$slopePart; $direction historical window average (${EpisodeDetailFormatters.rate(typicalSlope, unit: unit)})';
  }

  EpisodePatternViewModel _highPattern(
    List<GlucoseEvent> highEvents,
    DateTime? anchor,
  ) {
    final recent = _eventsInLastDays(highEvents, 14, anchor);
    final morning =
        recent.where((e) => e.time.hour >= 6 && e.time.hour < 12).toList();
    final range = _timeRange(morning);
    final patternText =
        morning.isEmpty
            ? 'No morning-window high episodes were detected in the 14-day analysis window.'
            : '${morning.length} morning-window high episodes were detected in the last 14 days. ${range == null ? 'The time cluster cannot be estimated from the current sample.' : 'Events occurred between $range.'}';
    return EpisodePatternViewModel(
      bigStat: '${morning.length}/14',
      description: 'Morning-window highs in the last 14 days',
      statColor: AppColors.amber,
      indicators: _dayIndicators(
        days: 7,
        strideDays: 2,
        anchor: anchor,
        events: morning,
        predicate: (event) => true,
      ),
      activeDotColor: AppColors.rose,
      patternText: patternText,
      caveat: 'n=${morning.length} | 14-day window | observation only',
    );
  }

  EpisodePatternViewModel _lowPattern(
    List<GlucoseEvent> lowEvents,
    DateTime? anchor,
  ) {
    final recent = _eventsInLastDays(lowEvents, 30, anchor);
    final nocturnal = recent.where((e) => e.isNocturnal).toList();
    final range = _timeRange(nocturnal);
    final patternText =
        nocturnal.isEmpty
            ? 'No nocturnal low episodes were detected in the 30-day analysis window.'
            : '${nocturnal.length} nocturnal low episodes were detected in the past 30 days. ${range == null ? 'The time cluster cannot be estimated from the current sample.' : 'They occurred between $range.'}';
    return EpisodePatternViewModel(
      bigStat: '${nocturnal.length}/30',
      description: 'Nocturnal low episodes in past 30 days',
      statColor: AppColors.blue,
      indicators: _dayIndicators(
        days: 7,
        strideDays: 5,
        anchor: anchor,
        events: nocturnal,
        predicate: (event) => true,
      ),
      activeDotColor: AppColors.blue,
      patternText: patternText,
      extraNote: _lowTimeDistribution(recent),
      caveat:
          'n=${nocturnal.length} nocturnal | 30-day window | observation only',
    );
  }

  List<PatternDayIndicator> _dayIndicators({
    required int days,
    required int strideDays,
    required DateTime? anchor,
    required List<GlucoseEvent> events,
    required bool Function(GlucoseEvent event) predicate,
  }) {
    final current = anchor ?? DateTime.now();
    final out = <PatternDayIndicator>[];
    for (var i = 0; i < days; i++) {
      final day = current.subtract(Duration(days: i * strideDays));
      final hadEvent = events.any(
        (event) =>
            event.time.year == day.year &&
            event.time.month == day.month &&
            event.time.day == day.day &&
            predicate(event),
      );
      out.add(
        PatternDayIndicator(
          label: EpisodeDetailFormatters.shortDate(day),
          active: hadEvent,
        ),
      );
    }
    return out;
  }

  String? _lowTimeDistribution(List<GlucoseEvent> events) {
    if (events.isEmpty) return null;
    var nocturnal = 0;
    var afternoon = 0;
    var other = 0;
    for (final event in events) {
      final hour = event.time.hour;
      if (event.isNocturnal) {
        nocturnal++;
      } else if (hour >= 12 && hour < 18) {
        afternoon++;
      } else {
        other++;
      }
    }
    String pct(int count) => '${(count / events.length * 100).round()}%';
    return 'Low episode distribution: ${pct(nocturnal)} nocturnal (00:00-06:00) | ${pct(afternoon)} afternoon | ${pct(other)} other';
  }

  List<EpisodeSimilarCardData> _similarCards({
    required GlucoseEvent current,
    required List<GlucoseEvent> events,
    required bool high,
    required Color themeColor,
    required GlucoseUnit unit,
  }) {
    final others =
        events.reversed
            .where(
              (event) =>
                  !identical(event, current) && event.time != current.time,
            )
            .take(3)
            .toList();
    return others.map((event) {
      final value = event.peakOrNadir ?? event.value;
      final duration = math.max(event.durationMinutes, 0);
      final rate = event.ratePerMin ?? 0.0;
      final range =
          event.endTime == null
              ? ''
              : ' | ${EpisodeDetailFormatters.range(event.time, event.endTime!)}';
      return EpisodeSimilarCardData(
        date: EpisodeDetailFormatters.shortDate(event.time),
        peakOrNadir: glucoseFormatter.value(value, unit).valueLabel,
        unit: glucoseFormatter.unitLabel(unit),
        durationText: '$duration min$range',
        rightTime: high ? EpisodeDetailFormatters.hm(event.time) : null,
        rightSlope:
            high ? EpisodeDetailFormatters.signedRate(rate, unit: unit) : null,
      );
    }).toList();
  }

  EpisodeSeverityViewModel _lowSeverity(double nadir, AppSettings settings) {
    final unit = settings.unit;
    final current =
        nadir < 2.8
            ? EpisodeSeverityLevel.severe
            : nadir < 3.0
            ? EpisodeSeverityLevel.significant
            : EpisodeSeverityLevel.mild;
    final nadirLabel = glucoseFormatter.value(nadir, unit).fullLabel;
    String range(double low, double high) =>
        '(${glucoseFormatter.range(low, high, unit).fullLabel})';
    String under(double threshold) =>
        '(<${glucoseFormatter.value(threshold, unit).valueLabel} ${glucoseFormatter.unitLabel(unit)})';
    return EpisodeSeverityViewModel(
      rows: [
        EpisodeSeverityRowViewModel(
          level: EpisodeSeverityLevel.mild,
          label: 'Mild',
          range: range(3.0, settings.lowThreshold),
          description: '$nadirLabel is compared with this threshold band.',
          isCurrent: current == EpisodeSeverityLevel.mild,
        ),
        EpisodeSeverityRowViewModel(
          level: EpisodeSeverityLevel.significant,
          label: 'Significant',
          range: range(2.8, 3.0),
          description: '$nadirLabel is compared with this threshold band.',
          isCurrent: current == EpisodeSeverityLevel.significant,
        ),
        EpisodeSeverityRowViewModel(
          level: EpisodeSeverityLevel.severe,
          label: 'Severe',
          range: under(2.8),
          description: '$nadirLabel is compared with this threshold band.',
          isCurrent: current == EpisodeSeverityLevel.severe,
        ),
      ],
      footnote:
          'Severity is derived from the episode nadir value in the current CGM event.',
    );
  }

  List<GlucoseEvent> _eventsInLastDays(
    List<GlucoseEvent> events,
    int days,
    DateTime? anchor,
  ) {
    if (events.isEmpty) return const [];
    final current = anchor ?? events.last.time;
    final cutoff = current.subtract(Duration(days: days));
    return events
        .where(
          (event) =>
              !event.time.isBefore(cutoff) && !event.time.isAfter(current),
        )
        .toList();
  }

  double _extremeValue(
    GlucoseEvent event,
    GlucoseReading? extremeReading,
    bool high,
  ) {
    if (extremeReading != null) return extremeReading.value;
    return event.peakOrNadir ?? event.value;
  }

  double _episodeRate(GlucoseEvent event, double? windowSlope, bool high) {
    final rate = event.ratePerMin ?? windowSlope ?? 0;
    return high ? rate.abs() : -rate.abs();
  }

  double _recoveryRate({
    required double extreme,
    required int duration,
    required bool high,
  }) {
    if (duration <= 0) return 0;
    return high
        ? -(extreme - 7.0).abs() / duration
        : (4.0 - extreme).abs() / duration;
  }

  double _episodeArea(
    GlucoseEvent event,
    double extreme,
    int duration,
    bool high,
    AppSettings settings,
  ) {
    if (event.areaOutOfRange != null) return event.areaOutOfRange!;
    final threshold = high ? settings.highThreshold : settings.lowThreshold;
    final distance =
        high
            ? math.max(0, extreme - threshold)
            : math.max(0, threshold - extreme);
    return distance * math.max(duration, 1).toDouble();
  }

  String? _timeRange(List<GlucoseEvent> events) {
    if (events.isEmpty) return null;
    final minutes =
        events.map((event) => event.time.hour * 60 + event.time.minute).toList()
          ..sort();
    final start = minutes.first;
    final end = minutes.last;
    String fmt(int value) =>
        '${(value ~/ 60).toString().padLeft(2, '0')}:'
        '${(value % 60).toString().padLeft(2, '0')}';
    return '${fmt(start)}-${fmt(end)}';
  }
}
