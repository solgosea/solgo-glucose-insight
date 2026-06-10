import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_result.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_result.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

void main() {
  test('sync result reports updated subject only when rows are stored', () {
    final changed = GlucoseSyncResult(
      source: DataSource.nightscout,
      subjectId: 'child-a',
      success: true,
      available: true,
      fetchedCount: 2,
      storedCount: 2,
      cursor: DateTime(2026, 6, 9, 12),
      error: null,
      readings: [
        GlucoseReading(
          timestamp: DateTime(2026, 6, 9, 11, 55),
          value: 5.6,
          ratePerMin: 0,
        ),
      ],
    );
    const unchanged = GlucoseSyncResult(
      source: DataSource.xdripHttp,
      subjectId: 'self',
      success: true,
      available: true,
      fetchedCount: 0,
      storedCount: 0,
      cursor: null,
      error: null,
      readings: [],
    );

    expect(changed.updatedSubjectIds, {'child-a'});
    expect(unchanged.updatedSubjectIds, isEmpty);
  });

  test('source sync result merges updated subjects from all targets', () {
    final result = GlucoseSourceSyncResult(
      sourceResults: [
        const GlucoseSyncResult(
          source: DataSource.nightscout,
          subjectId: 'child-a',
          success: true,
          available: true,
          fetchedCount: 1,
          storedCount: 1,
          cursor: null,
          error: null,
          readings: [],
        ),
        const GlucoseSyncResult(
          source: DataSource.nightscout,
          subjectId: 'child-b',
          success: true,
          available: true,
          fetchedCount: 1,
          storedCount: 1,
          cursor: null,
          error: null,
          readings: [],
        ),
        GlucoseSyncResult.failure(
          source: DataSource.xdripHttp,
          subjectId: 'self',
          error: 'offline',
        ),
      ],
    );

    expect(result.updatedSubjectIds, {'child-a', 'child-b'});
  });
}
