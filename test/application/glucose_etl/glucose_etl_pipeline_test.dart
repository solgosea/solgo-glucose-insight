import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/glucose_etl/glucose_etl_pipeline.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../_support/test_database.dart';

void main() {
  group('GlucoseEtlPipeline', () {
    test(
      'uses Nightscout as the deterministic winner for history buckets',
      () async {
        final database = TestDatabase.create();
        addTearDown(database.close);
        final now = DateTime(2026, 6, 5, 12);
        final sampleTime = now.subtract(const Duration(hours: 2));
        final pipeline = GlucoseEtlPipeline(database: database);

        await pipeline.run(
          source: 'nightscout',
          readings: [GlucoseReading(timestamp: sampleTime, value: 6.8)],
          now: now,
        );
        await pipeline.run(
          source: 'xdripHttp',
          readings: [
            GlucoseReading(
              timestamp: sampleTime.add(const Duration(seconds: 8)),
              value: 7.1,
            ),
          ],
          now: now,
        );

        final rows = await database.range(
          sampleTime.subtract(const Duration(minutes: 1)),
          sampleTime.add(const Duration(minutes: 1)),
        );

        expect(rows, hasLength(1));
        expect(rows.single.value, 6.8);
        expect(await database.rawReadings.count(), 2);
      },
    );

    test(
      'uses xDrip local as the deterministic winner for recent buckets',
      () async {
        final database = TestDatabase.create();
        addTearDown(database.close);
        final now = DateTime(2026, 6, 5, 12);
        final sampleTime = now.subtract(const Duration(minutes: 5));
        final pipeline = GlucoseEtlPipeline(database: database);

        await pipeline.run(
          source: 'nightscout',
          readings: [GlucoseReading(timestamp: sampleTime, value: 6.8)],
          now: now,
        );
        await pipeline.run(
          source: 'xdripHttp',
          readings: [
            GlucoseReading(
              timestamp: sampleTime.add(const Duration(seconds: 8)),
              value: 7.1,
            ),
          ],
          now: now,
        );

        final rows = await database.range(
          sampleTime.subtract(const Duration(minutes: 1)),
          sampleTime.add(const Duration(minutes: 1)),
        );

        expect(rows, hasLength(1));
        expect(rows.single.value, 7.1);
        expect(await database.rawReadings.count(), 2);
      },
    );
  });
}
