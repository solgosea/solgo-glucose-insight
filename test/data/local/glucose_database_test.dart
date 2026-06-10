import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../_support/test_database.dart';

void main() {
  group('GlucoseDatabase', () {
    test('upsertMany stores readings idempotently by timestamp', () async {
      final database = TestDatabase.create();
      final timestamp = DateTime(2026, 6, 4, 8);

      addTearDown(database.close);

      await database.upsertMany([
        GlucoseReading(timestamp: timestamp, value: 6.2),
        GlucoseReading(
          timestamp: timestamp.add(const Duration(minutes: 5)),
          value: 6.4,
        ),
      ]);
      await database.upsertMany([
        GlucoseReading(timestamp: timestamp, value: 7.1),
      ]);

      expect(await database.count(), 2);
      final rows = await database.range(
        timestamp.subtract(const Duration(minutes: 1)),
        timestamp.add(const Duration(minutes: 6)),
      );
      expect(rows.first.value, 7.1);
    });

    test('records source state attempts, success cursor, and errors', () async {
      final database = TestDatabase.create();
      addTearDown(database.close);

      await database.recordSourceAttempt('nightscout');
      var state = await database.getSourceState('nightscout');
      expect(state?.lastAttemptAt, isNotNull);
      expect(state?.lastSuccessAt, isNull);

      await database.recordSourceSuccess('nightscout', cursor: '12345');
      state = await database.getSourceState('nightscout');
      expect(state?.lastSuccessAt, isNotNull);
      expect(state?.lastCursor, '12345');
      expect(state?.lastError, isNull);

      await database.recordSourceError('nightscout', 'source_unavailable');
      state = await database.getSourceState('nightscout');
      expect(state?.lastError, 'source_unavailable');
    });
  });
}
