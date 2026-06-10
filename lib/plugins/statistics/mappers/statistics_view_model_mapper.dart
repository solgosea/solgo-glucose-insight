import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/engine/detection/dawn_phenomenon_detector.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp_chart.dart';
import '../models/statistics_view_model.dart';

class StatisticsViewModelMapper {
  static const _periods = [7, 14, 30, 90];
  static const _veryHighColor = Color(0xFFA03030);
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;

  const StatisticsViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
  });

  StatisticsViewModel map({
    required AnalysisFacade facade,
    required int selectedPeriod,
  }) {
    final readings = facade.readingsForLastDays(selectedPeriod);
    final previousReadings = facade.readingsForLastDays(
      selectedPeriod,
      now: _previousAnchor(facade, selectedPeriod),
    );
    final tir = facade.tirForReadings(readings);
    final previousTir = facade.tirForReadings(previousReadings);
    final agpSlots = facade.agpForReadings(readings);
    final hourlyTir = facade.hourlyTirForReadings(readings);
    final settings = facade.settings;

    return StatisticsViewModel(
      selectedPeriod: selectedPeriod,
      periodOptions:
          _periods
              .map(
                (days) => StatisticsPeriodOptionViewModel(
                  days: days,
                  label: '${days}d',
                  selected: days == selectedPeriod,
                ),
              )
              .toList(),
      metricsHeader: 'KEY METRICS - LAST $selectedPeriod DAYS',
      metrics: _metrics(tir, previousTir, selectedPeriod, settings),
      tirBreakdown: _tirBreakdown(tir, settings),
      agp: _agp(
        period: selectedPeriod,
        readings: readings,
        slots: agpSlots,
        facade: facade,
        settings: settings,
      ),
      heatmap: _heatmap(hourlyTir),
    );
  }

  DateTime? _previousAnchor(AnalysisFacade facade, int selectedPeriod) {
    final latest = facade.latestReading?.timestamp;
    if (latest == null) return null;
    return latest.subtract(Duration(days: selectedPeriod));
  }

  List<StatisticsMetricCardViewModel> _metrics(
    AnalysisTirResult current,
    AnalysisTirResult previous,
    int period,
    AppSettings settings,
  ) {
    final tirColor =
        current.tir >= 70
            ? AppColors.green
            : current.tir >= 50
            ? AppColors.amber
            : AppColors.rose;
    final cvColor = current.cv < 36 ? AppColors.green : AppColors.amber;

    final unit = settings.unit;
    final mean = glucoseFormatter.value(current.mean, unit);
    final previousMean = glucoseFormatter.value(previous.mean, unit);
    final sd = glucoseFormatter.value(current.sd, unit);
    final previousSd = glucoseFormatter.value(previous.sd, unit);
    final meanDelta = mean.value - previousMean.value;
    final sdDelta = sd.value - previousSd.value;

    return [
      StatisticsMetricCardViewModel(
        label: 'Time in Range',
        value: current.tir.toStringAsFixed(0),
        valueColor: tirColor,
        suffix: '%',
        unit: thresholdFormatter.targetRange(settings),
        deltaText: _deltaText(
          current.tir - previous.tir,
          suffix: '% vs prev ${period}d',
        ),
        deltaTone: _tone(current.tir - previous.tir, higherIsBetter: true),
      ),
      StatisticsMetricCardViewModel(
        label: 'Avg Glucose',
        value: mean.valueLabel,
        valueColor: AppColors.text,
        unit: '${mean.unitLabel} - GMI ${current.gmi.toStringAsFixed(1)}%',
        deltaText: _deltaText(meanDelta, suffix: ' ${mean.unitLabel}'),
        deltaTone: _tone(current.mean - previous.mean, higherIsBetter: false),
      ),
      StatisticsMetricCardViewModel(
        label: 'Variability CV',
        value: current.cv.toStringAsFixed(0),
        valueColor: cvColor,
        suffix: '%',
        unit: current.cv < 36 ? 'stable (<36%)' : 'elevated',
        deltaText: _deltaText(current.cv - previous.cv, suffix: '%'),
        deltaTone: _tone(current.cv - previous.cv, higherIsBetter: false),
      ),
      StatisticsMetricCardViewModel(
        label: 'Std Deviation',
        value: sd.valueLabel,
        valueColor: AppColors.text,
        unit: sd.unitLabel,
        deltaText: _deltaText(sdDelta, suffix: ' ${sd.unitLabel}'),
        deltaTone: _tone(current.sd - previous.sd, higherIsBetter: false),
      ),
    ];
  }

  StatisticsTirBreakdownViewModel _tirBreakdown(
    AnalysisTirResult tir,
    AppSettings settings,
  ) {
    final lowPct = tir.tbr;
    final inRangePct = tir.tir;
    final highOnlyPct = (tir.tar - tir.tarVeryHigh).clamp(0, 100).toDouble();
    final veryHighPct = tir.tarVeryHigh;
    final veryLowMin = (tir.tbrVeryLow / 100 * 1440).round();
    final veryHighMin = (veryHighPct / 100 * 1440).round();
    final veryLowLabel =
        '<${glucoseFormatter.value(3.0, settings.unit).valueLabel}';
    final veryHighLabel = thresholdFormatter.veryHighLabel(settings);

    final segments =
        [
          StatisticsTirSegmentViewModel(
            color: AppColors.blue,
            fraction: lowPct,
          ),
          StatisticsTirSegmentViewModel(
            color: AppColors.green,
            fraction: inRangePct,
          ),
          StatisticsTirSegmentViewModel(
            color: AppColors.rose,
            fraction: highOnlyPct,
          ),
          StatisticsTirSegmentViewModel(
            color: _veryHighColor,
            fraction: veryHighPct,
          ),
        ].where((segment) => segment.fraction > 0).toList();

    return StatisticsTirBreakdownViewModel(
      segments: segments,
      legends: [
        StatisticsLegendItemViewModel(
          color: AppColors.blue,
          text: 'Low ${lowPct.toStringAsFixed(0)}%',
        ),
        StatisticsLegendItemViewModel(
          color: AppColors.green,
          text: 'In range ${inRangePct.toStringAsFixed(0)}%',
        ),
        StatisticsLegendItemViewModel(
          color: AppColors.rose,
          text: 'High ${highOnlyPct.toStringAsFixed(0)}%',
        ),
        StatisticsLegendItemViewModel(
          color: _veryHighColor,
          text: 'Very high ${veryHighPct.toStringAsFixed(0)}%',
        ),
      ],
      extremes: [
        StatisticsExtremeCellViewModel(
          label: 'Very Low $veryLowLabel',
          value: '${tir.tbrVeryLow.toStringAsFixed(1)}%',
          subtitle: '~$veryLowMin min/day',
        ),
        StatisticsExtremeCellViewModel(
          label: 'Very High $veryHighLabel',
          value: '${veryHighPct.toStringAsFixed(0)}%',
          subtitle: '~$veryHighMin min/day',
        ),
      ],
    );
  }

  StatisticsAgpViewModel _agp({
    required int period,
    required List<GlucoseReading> readings,
    required List<AnalysisAgpSlot> slots,
    required AnalysisFacade facade,
    required AppSettings settings,
  }) {
    final dawn = _dawnAnalysis(readings);
    return StatisticsAgpViewModel(
      title: 'AGP - Ambulatory Glucose Profile - $period-day pattern',
      slots: slots,
      unit: settings.unit,
      lowThreshold: settings.lowThreshold,
      highThreshold: settings.highThreshold,
      annotations:
          dawn.consistent
              ? const [
                AgpAnnotation(
                  minuteOfDay: 300,
                  labels: ['Dawn', 'phenomenon'],
                  color: AppColors.amber,
                  opacity: 0.5,
                ),
              ]
              : const [],
      note: _agpNote(
        readings: readings,
        slots: slots,
        dawn: dawn,
        facade: facade,
        settings: settings,
      ),
    );
  }

  ({bool consistent, double averageRise, int significantDays, int observedDays})
  _dawnAnalysis(List<GlucoseReading> readings) {
    final rises = DawnPhenomenonDetector.detectDailyRises(readings);
    if (rises.isEmpty) {
      return (
        consistent: false,
        averageRise: 0.0,
        significantDays: 0,
        observedDays: 0,
      );
    }

    final significantDays = rises.where((rise) => rise >= 1.2).length;
    final requiredDays = (rises.length * 0.65).ceil().clamp(2, 10).toInt();
    final averageRise =
        rises.reduce((value, element) => value + element) / rises.length;

    return (
      consistent: significantDays >= requiredDays,
      averageRise: averageRise,
      significantDays: significantDays,
      observedDays: rises.length,
    );
  }

  String _agpNote({
    required List<GlucoseReading> readings,
    required List<AnalysisAgpSlot> slots,
    required ({
      bool consistent,
      double averageRise,
      int significantDays,
      int observedDays,
    })
    dawn,
    required AnalysisFacade facade,
    required AppSettings settings,
  }) {
    if (readings.isEmpty || slots.isEmpty) {
      return 'Not enough CGM data yet to draw an AGP profile.';
    }

    final variablePeriods = _periodVariability(facade, readings);
    final topPeriod = variablePeriods.isEmpty ? null : variablePeriods.first;
    final secondPeriod = variablePeriods.length > 1 ? variablePeriods[1] : null;
    final peak = _medianPeak(slots);
    final peakTime = _formatMinute(peak.minuteOfDay);
    final unit = settings.unit;

    final parts = <String>[];
    if (dawn.consistent) {
      parts.add(
        'A consistent pre-dawn rise between 04:00-07:00 appears on ${dawn.significantDays} of ${dawn.observedDays} observed days, with glucose climbing roughly ${glucoseFormatter.value(dawn.averageRise, unit).fullLabel} over that window.',
      );
    } else if (dawn.observedDays == 0) {
      parts.add(
        'The selected period does not contain enough paired 04:00-07:00 readings to evaluate a pre-dawn rise pattern.',
      );
    } else {
      parts.add(
        'The selected period does not show a consistent pre-dawn rise pattern; only ${dawn.significantDays} of ${dawn.observedDays} observed days crossed the rise threshold.',
      );
    }

    parts.add(
      'The median curve peaks near ${glucoseFormatter.value(peak.value, unit).fullLabel} around $peakTime.',
    );

    if (topPeriod != null && secondPeriod != null) {
      parts.add(
        '${topPeriod.label} is the most variable period by CV (${topPeriod.cv.toStringAsFixed(0)}%), followed by ${secondPeriod.label.toLowerCase()} (${secondPeriod.cv.toStringAsFixed(0)}%).',
      );
    } else if (topPeriod != null) {
      parts.add(
        '${topPeriod.label} is the most variable period by CV (${topPeriod.cv.toStringAsFixed(0)}%).',
      );
    } else {
      parts.add(
        'More period-level data is needed before identifying the most variable time window.',
      );
    }

    return parts.join(' ');
  }

  ({int minuteOfDay, double value}) _medianPeak(List<AnalysisAgpSlot> slots) {
    var best = slots.first;
    for (final slot in slots.skip(1)) {
      if (slot.p50 > best.p50) best = slot;
    }
    return (minuteOfDay: best.minuteOfDay, value: best.p50);
  }

  List<({String label, double cv})> _periodVariability(
    AnalysisFacade facade,
    List<GlucoseReading> readings,
  ) {
    final periods = [
      (label: 'Night', start: 0, end: 6),
      (label: 'Morning', start: 6, end: 12),
      (label: 'Afternoon', start: 12, end: 18),
      (label: 'Evening', start: 18, end: 24),
    ];
    final rows = <({String label, double cv})>[];
    for (final period in periods) {
      final periodReadings =
          readings
              .where(
                (reading) =>
                    reading.timestamp.hour >= period.start &&
                    reading.timestamp.hour < period.end,
              )
              .toList();
      if (periodReadings.isEmpty) continue;
      rows.add((
        label: period.label,
        cv: facade.tirForReadings(periodReadings).cv,
      ));
    }
    rows.sort((a, b) => b.cv.compareTo(a.cv));
    return rows;
  }

  StatisticsHeatmapViewModel _heatmap(List<double> hourlyTir) {
    return StatisticsHeatmapViewModel(
      title: 'Hourly TIR heatmap',
      cells: List.generate(24, (hour) {
        final value = hourlyTir.isNotEmpty ? hourlyTir[hour] : 0.0;
        return StatisticsHeatmapCellViewModel(color: _cellColor(value));
      }),
      labels: const ['00:00', '06:00', '12:00', '18:00', '24:00'],
    );
  }

  Color _cellColor(double tirPct) {
    final normalized = ((tirPct - 40) / 42).clamp(0.0, 1.0);
    int r;
    int g;
    int b;
    if (normalized < 0.45) {
      final f = normalized / 0.45;
      r = (240 + (110 - 240) * f).round();
      g = (180 + (232 - 180) * f).round();
      b = (78 + (158 - 78) * f).round();
    } else {
      r = 110;
      g = 232;
      b = 158;
    }
    final alpha = (0.15 + normalized * 0.68).clamp(0.0, 1.0);
    return Color.fromRGBO(r, g, b, alpha);
  }

  String _deltaText(double delta, {required String suffix}) {
    if (delta.abs() < 0.05) return 'same';
    final sign = delta > 0 ? '+' : '';
    return '$sign${delta.toStringAsFixed(1)}$suffix';
  }

  StatisticsDeltaTone _tone(double delta, {required bool higherIsBetter}) {
    if (delta.abs() < 0.05) return StatisticsDeltaTone.flat;
    final improved = higherIsBetter ? delta > 0 : delta < 0;
    return improved ? StatisticsDeltaTone.up : StatisticsDeltaTone.down;
  }

  String _formatMinute(int minuteOfDay) {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
