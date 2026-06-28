import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_plan.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_retry_policy.dart';
import 'package:smart_xdrip/application/sync/smart/smart_glucose_sync_chunker.dart';
import 'package:smart_xdrip/application/sync/smart/smart_glucose_sync_fetcher.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../../_support/fakes/fake_glucose_source.dart';

void main() {
  group('SmartGlucoseSyncChunker', () {
    test('splits multi-day initial windows into daily chunks', () {
      final from = DateTime(2026, 6, 1);
      final to = DateTime(2026, 6, 15);
      final chunks = const SmartGlucoseSyncChunker().chunksFor(
        GlucoseSyncPlan(
          from: from,
          to: to,
          initial: true,
          previousCursor: null,
        ),
      );

      expect(chunks, hasLength(14));
      expect(chunks.first.from, from);
      expect(chunks.first.to, DateTime(2026, 6, 2));
      expect(chunks.last.from, DateTime(2026, 6, 14));
      expect(chunks.last.to, to);
    });

    test('keeps small incremental windows as one chunk', () {
      final from = DateTime(2026, 6, 1, 12);
      final to = from.add(const Duration(minutes: 30));
      final chunks = const SmartGlucoseSyncChunker().chunksFor(
        GlucoseSyncPlan(
          from: from,
          to: to,
          initial: false,
          previousCursor: from,
        ),
      );

      expect(chunks, hasLength(1));
      expect(chunks.single.from, from);
      expect(chunks.single.to, to);
    });
  });

  group('SmartGlucoseSyncFetcher', () {
    test('fetches chunks, filters bounds, dedupes, and sorts readings',
        () async {
      final from = DateTime(2026, 6, 1);
      final to = DateTime(2026, 6, 3);
      final duplicateTime = DateTime(2026, 6, 1, 12);
      final source = FakeGlucoseSource(
        type: DataSource.nightscout,
        readings: [
          GlucoseReading(
            timestamp: from.subtract(const Duration(minutes: 5)),
            value: 5.0,
          ),
          GlucoseReading(timestamp: DateTime(2026, 6, 2, 6), value: 6.0),
          GlucoseReading(timestamp: duplicateTime, value: 5.8),
          GlucoseReading(timestamp: duplicateTime, value: 6.2),
          GlucoseReading(timestamp: to, value: 9.0),
        ],
      );

      final result = await SmartGlucoseSyncFetcher(
        retryPolicy: const GlucoseSyncRetryPolicy(),
      ).fetch(
        source: source,
        plan: GlucoseSyncPlan(
          from: from,
          to: to,
          initial: true,
          previousCursor: null,
        ),
      );

      expect(source.rangeCalls, 2);
      expect(source.rangeWindows.first.from, from);
      expect(source.rangeWindows.first.to, DateTime(2026, 6, 2));
      expect(result.readings.map((reading) => reading.timestamp), [
        duplicateTime,
        DateTime(2026, 6, 2, 6),
      ]);
      expect(result.readings.first.value, 6.2);
      expect(result.metrics.chunkCount, 2);
      expect(result.metrics.mergedCount, 2);
    });
  });
}
