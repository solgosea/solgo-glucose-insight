import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../models/history_view_model.dart';

class HistoryViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;

  const HistoryViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
  });

  HistoryViewModel map({
    required DateTime selectedDay,
    required List<GlucoseReading> readings,
    required List<GlucoseEvent> events,
    required AnalysisTirResult? tir,
    required bool isToday,
    required AppSettings settings,
  }) {
    final unit = settings.unit;
    return HistoryViewModel(
      dateNav: _dateNav(selectedDay, isToday),
      summaryChips: _summaryChips(tir, readings, settings),
      curve: _curve(readings, events, settings),
      stats: _stats(tir, readings, settings),
      episodeCallouts: _episodeCallouts(events, unit),
      events: events.map((event) => _eventRow(event, settings)).toList(),
    );
  }

  HistoryDateNavViewModel _dateNav(DateTime day, bool isToday) {
    final yearLabel = DateFormat('y').format(day);
    return HistoryDateNavViewModel(
      dateLabel: DateFormat('EEEE, MMM d').format(day),
      subtitle:
          isToday ? '$yearLabel - DAY VIEW  -  TODAY' : '$yearLabel - DAY VIEW',
      isToday: isToday,
    );
  }

  List<HistorySummaryChipViewModel> _summaryChips(
    AnalysisTirResult? tir,
    List<GlucoseReading> readings,
    AppSettings settings,
  ) {
    if (tir == null) return const [];
    final unit = settings.unit;
    final peak = _peak(readings);
    final peakLabel = glucoseFormatter.value(peak, unit).valueLabel;
    final meanLabel = glucoseFormatter.value(tir.mean, unit).valueLabel;
    return [
      HistorySummaryChipViewModel(
        text: 'TIR ${tir.tir.toStringAsFixed(0)}%',
        color: _tirColor(tir.tir),
      ),
      HistorySummaryChipViewModel(
        text: 'Peak $peakLabel',
        color:
            peak > settings.highThreshold ? AppColors.amber : AppColors.green,
      ),
      HistorySummaryChipViewModel(
        text: 'CV ${tir.cv.toStringAsFixed(0)}%',
        color: tir.cv < 36 ? AppColors.green : AppColors.amber,
      ),
      HistorySummaryChipViewModel(
        text: 'Avg $meanLabel',
        color:
            (tir.mean >= settings.lowThreshold &&
                    tir.mean <= settings.highThreshold)
                ? AppColors.green
                : AppColors.amber,
      ),
    ];
  }

  HistoryCurveViewModel _curve(
    List<GlucoseReading> readings,
    List<GlucoseEvent> events,
    AppSettings settings,
  ) {
    return HistoryCurveViewModel(
      readings: readings,
      unit: settings.unit,
      lowThreshold: settings.lowThreshold,
      highThreshold: settings.highThreshold,
      episodes: _chartEpisodes(events),
      markers: _chartMarkers(events),
    );
  }

  List<ChartEpisode> _chartEpisodes(List<GlucoseEvent> events) {
    final output = <ChartEpisode>[];
    for (final event in events) {
      final end = event.endTime;
      if (end == null) continue;
      if (event.type == GlucoseEventType.highEpisode) {
        output.add(
          ChartEpisode(start: event.time, end: end, color: AppColors.rose),
        );
      } else if (event.type == GlucoseEventType.lowEpisode) {
        output.add(
          ChartEpisode(start: event.time, end: end, color: AppColors.blue),
        );
      }
    }
    return output;
  }

  List<ChartEventMarker> _chartMarkers(List<GlucoseEvent> events) {
    final output = <ChartEventMarker>[];
    for (final event in events) {
      switch (event.type) {
        case GlucoseEventType.rise:
          output.add(
            ChartEventMarker(time: event.time, color: AppColors.amber),
          );
          break;
        case GlucoseEventType.highEpisode:
          output.add(ChartEventMarker(time: event.time, color: AppColors.rose));
          break;
        case GlucoseEventType.lowEpisode:
          output.add(ChartEventMarker(time: event.time, color: AppColors.blue));
          break;
        case GlucoseEventType.recovery:
          output.add(
            ChartEventMarker(time: event.time, color: AppColors.green),
          );
          break;
        case GlucoseEventType.stableWindow:
        case GlucoseEventType.firstReading:
        case GlucoseEventType.dawnPhenomenon:
          break;
      }
    }
    return output;
  }

  List<HistoryStatCardViewModel> _stats(
    AnalysisTirResult? tir,
    List<GlucoseReading> readings,
    AppSettings settings,
  ) {
    if (tir == null) return const [];
    final unit = settings.unit;
    final peak = _peak(readings);
    final mean = glucoseFormatter.value(tir.mean, unit);
    final peakDisplay = glucoseFormatter.value(peak, unit);
    return [
      HistoryStatCardViewModel(
        label: 'TIR',
        value: '${tir.tir.toStringAsFixed(0)}%',
        color: _tirColor(tir.tir),
      ),
      HistoryStatCardViewModel(
        label: 'AVG',
        value: mean.valueLabel,
        unit: mean.unitLabel,
        color: AppColors.text,
      ),
      HistoryStatCardViewModel(
        label: 'PEAK',
        value: peakDisplay.valueLabel,
        unit: peakDisplay.unitLabel,
        color: peak > settings.highThreshold ? AppColors.amber : AppColors.text,
      ),
      HistoryStatCardViewModel(
        label: 'CV',
        value: '${tir.cv.toStringAsFixed(0)}%',
        color: tir.cv < 36 ? AppColors.green : AppColors.amber,
      ),
    ];
  }

  List<HistoryEpisodeCalloutViewModel> _episodeCallouts(
    List<GlucoseEvent> events,
    GlucoseUnit unit,
  ) {
    final episodes =
        events
            .where(
              (event) =>
                  event.type == GlucoseEventType.highEpisode ||
                  event.type == GlucoseEventType.lowEpisode,
            )
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time));

    return episodes.map((event) {
      final isHigh = event.type == GlucoseEventType.highEpisode;
      final color = isHigh ? AppColors.rose : AppColors.blue;
      final value =
          glucoseFormatter
              .value(event.peakOrNadir ?? event.value, unit)
              .fullLabel;
      final extras = <String>[];
      if (event.isNocturnal && !isHigh) extras.add('Nocturnal low');
      if (event.ratePerMin != null && event.ratePerMin!.abs() > 0.05) {
        extras.add('rate ${_formatRate(event.ratePerMin, unit)}');
      }
      final extraText = extras.isEmpty ? '' : '. ${extras.join(', ')}.';

      return HistoryEpisodeCalloutViewModel(
        color: color,
        icon:
            isHigh ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
        label: isHigh ? 'High episode' : 'Low episode',
        summary:
            'at ${_hm(event.time)} - $value, lasted ${event.durationMinutes} min$extraText',
        actionLabel: 'View episode analysis ->',
        route: isHigh ? '/explore/high-episode' : '/explore/low-episode',
      );
    }).toList();
  }

  HistoryEventRowViewModel _eventRow(GlucoseEvent event, AppSettings settings) {
    final spec = _eventIconSpec(event.type);
    final tint = _eventIconTint(
      event.type,
      event.peakOrNadir ?? event.value,
      settings,
    );
    return HistoryEventRowViewModel(
      time: _hm(event.time),
      name: _eventName(event.type),
      icon: spec.icon,
      iconColor: spec.color,
      iconBackground: tint?.bg ?? spec.color.withOpacity(0.10),
      iconBorder: tint?.border ?? spec.color.withOpacity(0.30),
      detail: _eventDetail(event, settings),
      valueLabel: _eventValueLabel(event, settings.unit),
      valueColor: _eventValueColor(event, settings),
      tag: _eventTag(event, settings),
    );
  }

  String _eventName(GlucoseEventType type) => switch (type) {
    GlucoseEventType.highEpisode => 'Rise detected',
    GlucoseEventType.lowEpisode => 'Low episode',
    GlucoseEventType.rise => 'Rise detected',
    GlucoseEventType.recovery => 'Recovery to range',
    GlucoseEventType.stableWindow => 'Stable window',
    GlucoseEventType.firstReading => 'First reading of day',
    GlucoseEventType.dawnPhenomenon => 'Dawn phenomenon',
  };

  ({IconData icon, Color color}) _eventIconSpec(GlucoseEventType type) =>
      switch (type) {
        GlucoseEventType.highEpisode => (
          icon: Icons.arrow_upward_rounded,
          color: AppColors.rose,
        ),
        GlucoseEventType.lowEpisode => (
          icon: Icons.arrow_downward_rounded,
          color: AppColors.blue,
        ),
        GlucoseEventType.rise => (
          icon: Icons.trending_up_rounded,
          color: AppColors.amber,
        ),
        GlucoseEventType.recovery => (
          icon: Icons.south_east_rounded,
          color: AppColors.green,
        ),
        GlucoseEventType.stableWindow => (
          icon: Icons.timeline_rounded,
          color: AppColors.green,
        ),
        GlucoseEventType.firstReading => (
          icon: Icons.wb_sunny_outlined,
          color: AppColors.amber,
        ),
        GlucoseEventType.dawnPhenomenon => (
          icon: Icons.wb_twilight_rounded,
          color: AppColors.amber,
        ),
      };

  ({Color bg, Color border})? _eventIconTint(
    GlucoseEventType type,
    double value,
    AppSettings settings,
  ) {
    if (type == GlucoseEventType.highEpisode ||
        value > settings.highThreshold) {
      return (
        bg: AppColors.rose.withOpacity(0.12),
        border: AppColors.rose.withOpacity(0.25),
      );
    }
    if (type == GlucoseEventType.lowEpisode || value < settings.lowThreshold) {
      return (
        bg: AppColors.blue.withOpacity(0.12),
        border: AppColors.blue.withOpacity(0.25),
      );
    }
    if (type == GlucoseEventType.recovery ||
        type == GlucoseEventType.stableWindow) {
      return (
        bg: AppColors.green.withOpacity(0.12),
        border: AppColors.green.withOpacity(0.25),
      );
    }
    return null;
  }

  String _eventDetail(GlucoseEvent event, AppSettings settings) {
    final highValue =
        glucoseFormatter
            .value(settings.highThreshold, settings.unit)
            .valueLabel;
    final lowValue =
        glucoseFormatter.value(settings.lowThreshold, settings.unit).valueLabel;
    final unit = settings.unit;
    if (event.type == GlucoseEventType.highEpisode) {
      final rate = event.ratePerMin;
      final duration = event.durationMinutes;
      final rateText =
          rate != null ? glucoseFormatter.rate(rate, unit).fullLabel : '';
      return [
        if (rateText.isNotEmpty) rateText,
        if (duration > 0) '$duration min above $highValue',
      ].join(' - ');
    }
    if (event.type == GlucoseEventType.lowEpisode) {
      final duration = event.durationMinutes;
      return [
        if (event.isNocturnal) 'Nocturnal',
        if (duration > 0) '$duration min below $lowValue',
      ].join(' - ');
    }
    if (event.type == GlucoseEventType.firstReading) return 'Fasting glucose';
    if (event.type == GlucoseEventType.recovery) {
      final rate = event.ratePerMin;
      if (rate == null) return 'Back in range';
      return 'Back in range - ${glucoseFormatter.rate(rate, unit).fullLabel}';
    }
    if (event.type == GlucoseEventType.stableWindow) {
      return 'Low variability window';
    }
    return '';
  }

  String _eventValueLabel(GlucoseEvent event, GlucoseUnit unit) {
    final value =
        glucoseFormatter
            .value(event.peakOrNadir ?? event.value, unit)
            .fullLabel;
    final suffix =
        event.type == GlucoseEventType.highEpisode
            ? ' - peak'
            : (event.type == GlucoseEventType.rise ? ' - local peak' : '');
    return '$value$suffix';
  }

  Color _eventValueColor(GlucoseEvent event, AppSettings settings) {
    final value = event.peakOrNadir ?? event.value;
    if (value > settings.highThreshold) return AppColors.rose;
    if (value < settings.lowThreshold) return AppColors.blue;
    if (_isElevated(value, settings)) return AppColors.amber;
    return AppColors.text;
  }

  HistoryEventTagViewModel? _eventTag(
    GlucoseEvent event,
    AppSettings settings,
  ) {
    if (event.type == GlucoseEventType.highEpisode) {
      return const HistoryEventTagViewModel(
        text: 'high episode',
        color: AppColors.amber,
      );
    }
    if (event.type == GlucoseEventType.lowEpisode) {
      return const HistoryEventTagViewModel(
        text: 'low episode',
        color: AppColors.blue,
      );
    }
    if (event.type == GlucoseEventType.recovery) {
      return const HistoryEventTagViewModel(
        text: 'in range',
        color: AppColors.green,
      );
    }
    final value = event.peakOrNadir ?? event.value;
    if (event.type == GlucoseEventType.rise && _isElevated(value, settings)) {
      return const HistoryEventTagViewModel(
        text: 'elevated',
        color: AppColors.amber,
      );
    }
    return null;
  }

  bool _isElevated(double value, AppSettings settings) {
    final lowerBand =
        settings.highThreshold -
        (settings.highThreshold - settings.lowThreshold) * 0.15;
    return value >= lowerBand && value <= settings.highThreshold;
  }

  String _hm(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  String _formatRate(double? rate, GlucoseUnit unit) {
    if (rate == null) return '';
    return glucoseFormatter.rate(rate, unit).fullLabel;
  }

  Color _tirColor(double tir) {
    if (tir >= 70) return AppColors.green;
    if (tir >= 50) return AppColors.amber;
    return AppColors.rose;
  }

  double _peak(List<GlucoseReading> readings) {
    if (readings.isEmpty) return 0;
    return readings
        .map((reading) => reading.value)
        .reduce((a, b) => a > b ? a : b);
  }
}
