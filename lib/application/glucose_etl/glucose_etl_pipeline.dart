import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_etl/glucose_etl_result.dart';
import 'package:smart_xdrip/domain/glucose_etl/raw_glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import 'normalize/raw_glucose_reading_normalizer.dart';
import 'transform/glucose_canonical_merge_policy.dart';

class GlucoseEtlPipeline {
  final GlucoseDatabase database;
  final RawGlucoseReadingNormalizer normalizer;
  final GlucoseCanonicalMergePolicy mergePolicy;

  const GlucoseEtlPipeline({
    required this.database,
    this.normalizer = const RawGlucoseReadingNormalizer(),
    this.mergePolicy = const GlucoseCanonicalMergePolicy(),
  });

  Future<GlucoseEtlResult> run({
    required String source,
    required List<GlucoseReading> readings,
    DateTime? now,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final raw = normalizer.normalize(
      source: source,
      readings: readings,
      receivedAt: now,
    );
    await database.upsertRawReadings(raw, subjectId: subjectId);

    final buckets = raw.map((reading) => reading.bucketMs).toSet();
    final candidates = await database.rawReadingsByBuckets(
      buckets,
      subjectId: subjectId,
    );
    final canonical = <int, List<RawGlucoseReading>>{};
    for (final candidate in candidates) {
      canonical.putIfAbsent(candidate.bucketMs, () => []).add(candidate);
    }

    final winners =
        canonical.entries
            .map(
              (entry) => mergePolicy.choose(
                bucketMs: entry.key,
                candidates: entry.value,
                now: now,
              ),
            )
            .toList()
          ..sort((a, b) => a.bucketMs.compareTo(b.bucketMs));

    await database.upsertCanonicalReadings(winners, subjectId: subjectId);
    return GlucoseEtlResult(rawReadings: raw, canonicalReadings: winners);
  }
}
