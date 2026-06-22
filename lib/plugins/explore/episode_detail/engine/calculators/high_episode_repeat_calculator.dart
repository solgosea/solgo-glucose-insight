import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../../domain/episode_repeat_chart_dataset.dart';
import '../../domain/episode_repeat_day_mark.dart';
import '../../domain/episode_repeat_time_block_bucket.dart';
import '../../domain/high_episode_repeat_pattern.dart';
import '../rules/high_repeat/high_episode_repeat_rule_catalog.dart';

class HighEpisodeRepeatCalculator {
  final HighEpisodeRepeatRuleCatalog rules;

  const HighEpisodeRepeatCalculator({
    this.rules = const HighEpisodeRepeatRuleCatalog(),
  });

  HighEpisodeRepeatPattern calculate({
    required List<GlucoseEvent> highEvents,
    required GlucoseEvent focus,
    required DateTime? anchor,
  }) {
    const windowDays = 30;
    final current = anchor ?? focus.time;
    final recent = _eventsInLastDays(highEvents, windowDays, current);
    final morning =
        recent.where((e) => e.time.hour >= 8 && e.time.hour < 12).toList();
    final dawn =
        recent.where((e) => e.time.hour >= 6 && e.time.hour < 8).toList();
    final evening =
        recent.where((e) => e.time.hour >= 18 && e.time.hour < 24).toList();
    final sameTime = recent
        .where((e) =>
            (e.time.hour * 60 + e.time.minute)
                .differenceAbs(focus.time.hour * 60 + focus.time.minute) <=
            45)
        .toList();
    final type = rules.classify(
      morningCount: morning.length + dawn.length,
      eveningCount: evening.length,
      sameTimeCount: sameTime.length,
    );
    final selected = switch (type) {
      HighEpisodeRepeatPatternType.morning => [...dawn, ...morning],
      HighEpisodeRepeatPatternType.evening => evening,
      HighEpisodeRepeatPatternType.sameTime => sameTime,
      HighEpisodeRepeatPatternType.none => const <GlucoseEvent>[],
    };
    final chartDataset = _chartDataset(
      windowDays: windowDays,
      anchor: current,
      focus: focus,
      recent: recent,
      selected: selected,
    );
    return HighEpisodeRepeatPattern(
      type: type,
      count: selected.length,
      windowDays: windowDays,
      range: _timeRange(selected),
      indicators: _indicatorsFromDataset(chartDataset),
      chartDataset: chartDataset,
    );
  }

  List<GlucoseEvent> _eventsInLastDays(
    List<GlucoseEvent> events,
    int days,
    DateTime anchor,
  ) {
    if (events.isEmpty) return const [];
    final cutoff = anchor.subtract(Duration(days: days - 1));
    return events
        .where((event) =>
            !_dateOnly(event.time).isBefore(_dateOnly(cutoff)) &&
            !_dateOnly(event.time).isAfter(_dateOnly(anchor)))
        .toList();
  }

  EpisodeRepeatChartDataset _chartDataset({
    required int windowDays,
    required DateTime anchor,
    required GlucoseEvent focus,
    required List<GlucoseEvent> recent,
    required List<GlucoseEvent> selected,
  }) {
    final buckets = _timeBlockBuckets(recent);
    final dominant = buckets.reduce(
      (best, bucket) => bucket.count > best.count ? bucket : best,
    );
    final dominantEvents = recent
        .where((event) => _blockLabel(event.time) == dominant.label)
        .toList();
    return EpisodeRepeatChartDataset(
      windowDays: windowDays,
      repeatCount: selected.length,
      dominantBlockLabel: dominant.label,
      dominantRangeLabel: _timeRange(dominantEvents),
      dayMarks: _dayMarks(
        windowDays: windowDays,
        anchor: anchor,
        focus: focus,
        recent: recent,
        selected: selected,
      ),
      timeBlockBuckets: buckets,
      takeaway: '',
    );
  }

  List<EpisodeRepeatDayMark> _dayMarks({
    required int windowDays,
    required DateTime anchor,
    required GlucoseEvent focus,
    required List<GlucoseEvent> recent,
    required List<GlucoseEvent> selected,
  }) {
    final out = <EpisodeRepeatDayMark>[];
    for (var offset = windowDays - 1; offset >= 0; offset--) {
      final day = _dateOnly(anchor.subtract(Duration(days: offset)));
      final hasEpisode = recent.any((event) => _sameDay(event.time, day));
      final isStrong = selected.any((event) => _sameDay(event.time, day));
      out.add(EpisodeRepeatDayMark(
        date: day,
        hasEpisode: hasEpisode,
        isCurrent: _sameDay(focus.time, day),
        isStrong: isStrong,
      ));
    }
    return out;
  }

  List<EpisodeRepeatTimeBlockBucket> _timeBlockBuckets(
    List<GlucoseEvent> events,
  ) {
    final labels = ['Night', 'Dawn', 'Morning', 'Afternoon', 'Evening'];
    final counts = {for (final label in labels) label: 0};
    for (final event in events) {
      counts[_blockLabel(event.time)] =
          (counts[_blockLabel(event.time)] ?? 0) + 1;
    }
    final maxCount = math.max(1, counts.values.fold<int>(0, math.max));
    final sortedCounts = counts.values.toList()..sort();
    final secondHighest =
        sortedCounts.length < 2 ? 0 : sortedCounts[sortedCounts.length - 2];
    return [
      for (final label in labels)
        EpisodeRepeatTimeBlockBucket(
          label: label,
          count: counts[label] ?? 0,
          normalizedHeight: (counts[label] ?? 0) / maxCount,
          isDominant: (counts[label] ?? 0) == maxCount && maxCount > 0,
          isSecondary: (counts[label] ?? 0) == secondHighest &&
              secondHighest > 0 &&
              secondHighest < maxCount,
        ),
    ];
  }

  List<HighEpisodeRepeatIndicator> _indicatorsFromDataset(
    EpisodeRepeatChartDataset dataset,
  ) {
    return dataset.dayMarks
        .where((mark) => mark.hasEpisode || mark.isCurrent)
        .take(7)
        .map(
          (mark) => HighEpisodeRepeatIndicator(
            label: _shortDate(mark.date),
            active: mark.hasEpisode,
          ),
        )
        .toList();
  }

  String _blockLabel(DateTime time) {
    final hour = time.hour;
    if (hour < 6) return 'Night';
    if (hour < 8) return 'Dawn';
    if (hour < 12) return 'Morning';
    if (hour < 18) return 'Afternoon';
    return 'Evening';
  }

  String? _timeRange(List<GlucoseEvent> events) {
    if (events.isEmpty) return null;
    final minutes = events
        .map((event) => event.time.hour * 60 + event.time.minute)
        .toList()
      ..sort();
    final start = minutes.first;
    final end = minutes.last;
    String fmt(int value) => '${(value ~/ 60).toString().padLeft(2, '0')}:'
        '${(value % 60).toString().padLeft(2, '0')}';
    return '${fmt(start)}-${fmt(end)}';
  }

  bool _sameDay(DateTime left, DateTime right) =>
      left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  String _shortDate(DateTime value) {
    return '${_monthShort(value.month)} ${value.day}';
  }

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
}

extension on int {
  int differenceAbs(int other) => (this - other).abs();
}
