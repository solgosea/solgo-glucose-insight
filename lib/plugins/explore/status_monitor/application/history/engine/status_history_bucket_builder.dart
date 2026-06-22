import '../../../domain/history/status_component_history_sample.dart';
import '../../../domain/history/status_history_bucket.dart';
import '../../../domain/status_component_kind.dart';
import '../policies/component_history_policy_registry.dart';

class StatusHistoryBucketBuilder {
  final ComponentHistoryPolicyRegistry? policyRegistry;

  const StatusHistoryBucketBuilder({
    this.policyRegistry,
  });

  List<List<StatusHistoryBucket>> buildHourlyBuckets({
    required StatusComponentKind component,
    required DateTime now,
    required List<StatusComponentHistorySample> samples,
  }) {
    final policy = (policyRegistry ?? ComponentHistoryPolicyRegistry())
        .policyFor(component);
    final days = _lastSevenDayStarts(now);
    return [
      for (final day in days)
        [
          for (var hour = 0; hour < 24; hour++)
            policy.calculateHour(
              hourStart: _dateTime(now, day.year, day.month, day.day, hour),
              now: now,
              samples: samples,
            ),
        ],
    ];
  }

  List<DateTime> _lastSevenDayStarts(DateTime now) {
    final today = _dateTime(now, now.year, now.month, now.day);
    return [
      for (var i = 6; i >= 0; i--) today.subtract(Duration(days: i)),
    ];
  }

  DateTime _dateTime(
    DateTime basis,
    int year,
    int month,
    int day, [
    int hour = 0,
  ]) {
    return basis.isUtc
        ? DateTime.utc(year, month, day, hour)
        : DateTime(year, month, day, hour);
  }
}
