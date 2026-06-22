import '../../../domain/component_health.dart';
import '../../../domain/history/status_component_history_result.dart';
import '../../../domain/history/status_component_history_sample.dart';
import '../../../domain/history/status_history_query.dart';
import '../../../domain/history/status_history_result.dart';
import 'status_history_bucket_builder.dart';
import 'status_history_coverage_calculator.dart';
import 'status_history_daily_aggregator.dart';

class StatusHistoryEngine {
  final StatusHistoryBucketBuilder bucketBuilder;
  final StatusHistoryDailyAggregator dailyAggregator;
  final StatusHistoryCoverageCalculator coverageCalculator;

  const StatusHistoryEngine({
    this.bucketBuilder = const StatusHistoryBucketBuilder(),
    this.dailyAggregator = const StatusHistoryDailyAggregator(),
    this.coverageCalculator = const StatusHistoryCoverageCalculator(),
  });

  StatusHistoryResult calculate({
    required StatusHistoryQuery query,
    required List<ComponentHealth> components,
    required List<StatusComponentHistorySample> samples,
    required DateTime now,
  }) {
    return StatusHistoryResult(
      query: query,
      components: [
        for (final component in components)
          _componentResult(
            component: component,
            samples: samples
                .where((sample) => sample.component == component.kind)
                .toList(growable: false),
            now: now,
          ),
      ],
    );
  }

  StatusComponentHistoryResult _componentResult({
    required ComponentHealth component,
    required List<StatusComponentHistorySample> samples,
    required DateTime now,
  }) {
    final hourly = bucketBuilder.buildHourlyBuckets(
      component: component.kind,
      now: now,
      samples: samples,
    );
    final days = _lastSevenDayStarts(now);
    return StatusComponentHistoryResult(
      component: component.kind,
      currentLevel: component.level,
      dailyBuckets: [
        for (var i = 0; i < days.length; i++)
          dailyAggregator.aggregate(
            component: component.kind,
            dayStart: days[i],
            hours: hourly[i],
          ),
      ],
      hourlyBuckets: hourly,
      coverage: coverageCalculator.calculate(hourly),
    );
  }

  List<DateTime> _lastSevenDayStarts(DateTime now) {
    final today = now.isUtc
        ? DateTime.utc(now.year, now.month, now.day)
        : DateTime(now.year, now.month, now.day);
    return [
      for (var i = 6; i >= 0; i--) today.subtract(Duration(days: i)),
    ];
  }
}
