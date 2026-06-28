import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync_window/sync_window_coverage_resolver.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';

import '../../_support/fakes/fake_glucose_source.dart';
import '../../_support/test_database.dart';

void main() {
  test('uses actual local readings to correct stale recorded coverage',
      () async {
    final now = DateTime(2026, 6, 24, 12);
    final database = TestDatabase.create();
    addTearDown(database.close);
    await database.recordSourceSuccess(
      'nightscout',
      subjectId: GlucoseSubject.selfId,
      coveredFrom: now.subtract(const Duration(days: 30)),
      coveredTo: now,
      syncWindowDays: 30,
    );
    await database.upsertMany([
      GlucoseReading(
        timestamp: now.subtract(const Duration(days: 1)),
        value: 6.4,
      ),
      GlucoseReading(timestamp: now, value: 6.8),
    ]);

    final coverage =
        await SyncWindowCoverageResolver(database: database).resolve(_target());

    expect(coverage.coveredFrom, now.subtract(const Duration(days: 1)));
    expect(coverage.coveredTo, now);
    expect(coverage.syncWindowDays, 30);
  });

  test('returns empty coverage when state exists but no readings are stored',
      () async {
    final now = DateTime(2026, 6, 24, 12);
    final database = TestDatabase.create();
    addTearDown(database.close);
    await database.recordSourceSuccess(
      'nightscout',
      subjectId: GlucoseSubject.selfId,
      coveredFrom: now.subtract(const Duration(days: 30)),
      coveredTo: now,
      syncWindowDays: 30,
    );

    final coverage =
        await SyncWindowCoverageResolver(database: database).resolve(_target());

    expect(coverage.coveredFrom, isNull);
    expect(coverage.coveredTo, isNull);
    expect(coverage.syncWindowDays, 30);
  });
}

GlucoseSyncTarget _target() => GlucoseSyncTarget(
      targetId: 'self:nightscout',
      subjectId: GlucoseSubject.selfId,
      label: 'Nightscout',
      kind: GlucoseSyncTargetKind.selfNightscout,
      source: FakeGlucoseSource(
        type: DataSource.nightscout,
        readings: [],
      ),
      primaryHistory: true,
    );
