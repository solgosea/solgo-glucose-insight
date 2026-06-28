import '../glucose_sync_plan.dart';
import 'smart_glucose_sync_chunk.dart';
import 'smart_glucose_sync_chunk_policy.dart';

class SmartGlucoseSyncChunker {
  final SmartGlucoseSyncChunkPolicy policy;

  const SmartGlucoseSyncChunker({
    this.policy = const SmartGlucoseSyncChunkPolicy(),
  });

  List<SmartGlucoseSyncChunk> chunksFor(GlucoseSyncPlan plan) {
    if (!plan.from.isBefore(plan.to)) return const [];
    final total = plan.to.difference(plan.from);
    if (total <= policy.chunkSize || total <= policy.minChunkSize) {
      return [
        SmartGlucoseSyncChunk(from: plan.from, to: plan.to, index: 0),
      ];
    }

    final chunks = <SmartGlucoseSyncChunk>[];
    var cursor = plan.from;
    var index = 0;
    while (cursor.isBefore(plan.to)) {
      final proposedEnd = cursor.add(policy.chunkSize);
      final end = proposedEnd.isBefore(plan.to) ? proposedEnd : plan.to;
      chunks.add(
        SmartGlucoseSyncChunk(from: cursor, to: end, index: index++),
      );
      cursor = end;
    }
    return chunks;
  }
}
