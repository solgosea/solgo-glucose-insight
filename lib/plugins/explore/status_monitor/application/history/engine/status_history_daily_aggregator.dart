import '../../../domain/history/status_history_bucket.dart';
import '../../../domain/history/status_history_bucket_reason.dart';
import '../../../domain/status_component_kind.dart';
import '../../../domain/status_level.dart';

class StatusHistoryDailyAggregator {
  const StatusHistoryDailyAggregator();

  StatusHistoryBucket aggregate({
    required StatusComponentKind component,
    required DateTime dayStart,
    required List<StatusHistoryBucket> hours,
  }) {
    final level = _worstLevel(hours.map((bucket) => bucket.level));
    final recorded = hours.any(
      (bucket) => bucket.reason == StatusHistoryBucketReason.recordedSample,
    );
    final carried = hours.any(
      (bucket) => bucket.reason == StatusHistoryBucketReason.carriedForward,
    );
    return StatusHistoryBucket(
      component: component,
      start: dayStart,
      end: dayStart.add(const Duration(days: 1)),
      level: level,
      summary: _summary(level),
      reason: recorded
          ? StatusHistoryBucketReason.recordedSample
          : carried
              ? StatusHistoryBucketReason.carriedForward
              : StatusHistoryBucketReason.noSample,
    );
  }

  StatusLevel _worstLevel(Iterable<StatusLevel> levels) {
    if (levels.contains(StatusLevel.issue)) return StatusLevel.issue;
    if (levels.contains(StatusLevel.watch)) return StatusLevel.watch;
    if (levels.contains(StatusLevel.healthy)) return StatusLevel.healthy;
    return StatusLevel.unknown;
  }

  String _summary(StatusLevel level) {
    return switch (level) {
      StatusLevel.issue => 'Issue recorded during this day',
      StatusLevel.watch => 'Watch recorded during this day',
      StatusLevel.healthy => 'Healthy samples recorded during this day',
      StatusLevel.unknown => 'No enough samples for this day',
    };
  }
}
