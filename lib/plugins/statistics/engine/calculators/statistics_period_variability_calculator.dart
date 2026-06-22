import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../domain/statistics_period_variability.dart';
import 'statistics_tir_calculator.dart';

class StatisticsPeriodVariabilityCalculator {
  final StatisticsTirCalculator tirCalculator;

  const StatisticsPeriodVariabilityCalculator({
    this.tirCalculator = const StatisticsTirCalculator(),
  });

  List<StatisticsPeriodVariability> calculate({
    required List<GlucoseReading> readings,
    required AppSettings settings,
  }) {
    final periods = [
      (label: 'night', start: 0, end: 6),
      (label: 'morning', start: 6, end: 12),
      (label: 'afternoon', start: 12, end: 18),
      (label: 'evening', start: 18, end: 24),
    ];
    final rows = <StatisticsPeriodVariability>[];
    for (final period in periods) {
      final periodReadings = readings
          .where(
            (reading) =>
                reading.timestamp.hour >= period.start &&
                reading.timestamp.hour < period.end,
          )
          .toList();
      if (periodReadings.isEmpty) continue;
      rows.add(
        StatisticsPeriodVariability(
          label: period.label,
          cv: tirCalculator.calculate(periodReadings, settings).cv,
        ),
      );
    }
    rows.sort((a, b) => b.cv.compareTo(a.cv));
    return rows;
  }
}
