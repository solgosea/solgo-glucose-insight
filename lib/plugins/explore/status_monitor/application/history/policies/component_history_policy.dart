import '../../../domain/history/status_component_history_sample.dart';
import '../../../domain/history/status_history_bucket.dart';
import '../../../domain/history/status_history_bucket_reason.dart';
import '../../../domain/history/status_history_policy_config.dart';
import '../../../domain/status_component_kind.dart';
import '../../../domain/status_level.dart';

abstract class ComponentHistoryPolicy {
  StatusComponentKind get component;
  StatusHistoryPolicyConfig get config;

  StatusHistoryBucket calculateHour({
    required DateTime hourStart,
    required DateTime now,
    required List<StatusComponentHistorySample> samples,
  }) {
    final hourEnd = hourStart.add(const Duration(hours: 1));
    if (hourStart.isAfter(now)) {
      return _empty(
        hourStart: hourStart,
        hourEnd: hourEnd,
        reason: StatusHistoryBucketReason.future,
        summary: 'Future hour',
      );
    }

    final recorded = _latestInHour(samples, hourStart, hourEnd);
    if (recorded != null) {
      return StatusHistoryBucket(
        component: component,
        start: hourStart,
        end: hourEnd,
        level: recorded.level,
        score: recorded.score,
        summary: recorded.summary,
        reason: StatusHistoryBucketReason.recordedSample,
        sample: recorded,
      );
    }

    final carried = _latestBefore(samples, hourStart);
    if (carried != null &&
        hourStart.difference(carried.at) <= config.carryForwardTtl) {
      return StatusHistoryBucket(
        component: component,
        start: hourStart,
        end: hourEnd,
        level: carried.level,
        score: carried.score,
        summary: carried.summary,
        reason: StatusHistoryBucketReason.carriedForward,
        sample: carried,
      );
    }

    return _empty(
      hourStart: hourStart,
      hourEnd: hourEnd,
      reason: StatusHistoryBucketReason.noSample,
      summary: 'No status sample for this hour',
    );
  }

  StatusComponentHistorySample? _latestInHour(
    List<StatusComponentHistorySample> samples,
    DateTime start,
    DateTime end,
  ) {
    StatusComponentHistorySample? latest;
    for (final sample in samples) {
      if (sample.at.isBefore(start) || !sample.at.isBefore(end)) continue;
      if (latest == null || sample.at.isAfter(latest.at)) latest = sample;
    }
    return latest;
  }

  StatusComponentHistorySample? _latestBefore(
    List<StatusComponentHistorySample> samples,
    DateTime start,
  ) {
    StatusComponentHistorySample? latest;
    for (final sample in samples) {
      if (!sample.at.isBefore(start)) continue;
      if (latest == null || sample.at.isAfter(latest.at)) latest = sample;
    }
    return latest;
  }

  StatusHistoryBucket _empty({
    required DateTime hourStart,
    required DateTime hourEnd,
    required StatusHistoryBucketReason reason,
    required String summary,
  }) {
    return StatusHistoryBucket(
      component: component,
      start: hourStart,
      end: hourEnd,
      level: StatusLevel.unknown,
      summary: summary,
      reason: reason,
    );
  }
}
