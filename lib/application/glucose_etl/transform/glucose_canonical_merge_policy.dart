import 'dart:math' as math;

import 'package:smart_xdrip/domain/glucose_etl/canonical_glucose_candidate.dart';
import 'package:smart_xdrip/domain/glucose_etl/raw_glucose_reading.dart';

import 'glucose_source_priority_policy.dart';

class GlucoseCanonicalMergePolicy {
  final GlucoseSourcePriorityPolicy priorityPolicy;

  const GlucoseCanonicalMergePolicy({
    this.priorityPolicy = const GlucoseSourcePriorityPolicy(),
  });

  CanonicalGlucoseCandidate choose({
    required int bucketMs,
    required List<RawGlucoseReading> candidates,
    DateTime? now,
  }) {
    if (candidates.isEmpty) {
      throw ArgumentError.value(candidates, 'candidates', 'must not be empty');
    }

    final sorted = [...candidates]..sort((a, b) {
      final aScore = _score(a, now);
      final bScore = _score(b, now);
      final scoreCompare = bScore.compareTo(aScore);
      if (scoreCompare != 0) return scoreCompare;

      final aDistance = (a.timestamp.millisecondsSinceEpoch - bucketMs).abs();
      final bDistance = (b.timestamp.millisecondsSinceEpoch - bucketMs).abs();
      final distanceCompare = aDistance.compareTo(bDistance);
      if (distanceCompare != 0) return distanceCompare;

      final sourceCompare = _sourceOrder(
        a.source,
      ).compareTo(_sourceOrder(b.source));
      if (sourceCompare != 0) return sourceCompare;

      return a.id.compareTo(b.id);
    });

    final winner = sorted.first;
    return CanonicalGlucoseCandidate(
      bucketMs: bucketMs,
      timestamp: winner.timestamp,
      value: winner.value,
      ratePerMin: winner.ratePerMin,
      source: winner.source,
      rawId: winner.id,
      sourcePriority: priorityPolicy.priority(
        source: winner.source,
        readingTime: winner.timestamp,
        now: now,
      ),
      updatedAt: now ?? DateTime.now(),
    );
  }

  int _score(RawGlucoseReading reading, DateTime? now) {
    final sourcePriority = priorityPolicy.priority(
      source: reading.source,
      readingTime: reading.timestamp,
      now: now,
    );
    final completeness = reading.ratePerMin == null ? 0 : 5;
    final identity = reading.sourceRecordId.isEmpty ? 0 : 3;
    return math.max(0, sourcePriority + completeness + identity);
  }

  int _sourceOrder(String source) {
    return switch (source) {
      'nightscout' => 0,
      'xdripHttp' => 1,
      _ => 9,
    };
  }
}
