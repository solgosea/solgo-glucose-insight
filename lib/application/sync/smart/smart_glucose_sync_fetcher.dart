import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../glucose_sync_plan.dart';
import '../glucose_sync_retry_policy.dart';
import 'smart_glucose_sync_chunker.dart';
import 'smart_glucose_sync_fetch_result.dart';
import 'smart_glucose_sync_merge_policy.dart';
import 'smart_glucose_sync_metrics.dart';

class SmartGlucoseSyncFetcher {
  final SmartGlucoseSyncChunker chunker;
  final SmartGlucoseSyncMergePolicy mergePolicy;
  final GlucoseSyncRetryPolicy retryPolicy;

  const SmartGlucoseSyncFetcher({
    this.chunker = const SmartGlucoseSyncChunker(),
    this.mergePolicy = const SmartGlucoseSyncMergePolicy(),
    required this.retryPolicy,
  });

  Future<SmartGlucoseSyncFetchResult> fetch({
    required IGlucoseSource source,
    required GlucoseSyncPlan plan,
  }) async {
    final chunks = chunker.chunksFor(plan);
    final raw = <GlucoseReading>[];
    for (final chunk in chunks) {
      final readings = await retryPolicy.run(
        () => source.range(from: chunk.from, to: chunk.to),
      );
      raw.addAll(readings);
    }
    final merged = mergePolicy.merge(
      readings: raw,
      from: plan.from,
      to: plan.to,
    );
    return SmartGlucoseSyncFetchResult(
      readings: merged,
      metrics: SmartGlucoseSyncMetrics(
        chunkCount: chunks.length,
        rawFetchedCount: raw.length,
        mergedCount: merged.length,
      ),
    );
  }
}
