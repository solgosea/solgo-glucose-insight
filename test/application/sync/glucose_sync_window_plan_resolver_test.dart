import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_plan.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_policy.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_window_plan_resolver.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import '../../_support/test_database.dart';

void main() {
  test('plans window backfill when recorded coverage is older than real data',
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
    ]);
    final state = await database.getSourceState('nightscout');

    final plan = await const GlucoseSyncWindowPlanResolver().resolve(
      database: database,
      subjectId: GlucoseSubject.selfId,
      state: state,
      policy: const GlucoseSyncPolicy(initialSyncDays: 30),
      now: now,
    );

    expect(plan, isNotNull);
    expect(plan!.reason, GlucoseSyncPlanReason.windowBackfill);
    expect(plan.from, now.subtract(const Duration(days: 30)));
    expect(plan.to, now.subtract(const Duration(days: 1)));
  });

  test('does not repeat backfill when recorded coverage matches real data',
      () async {
    final now = DateTime(2026, 6, 24, 12);
    final database = TestDatabase.create();
    addTearDown(database.close);
    final actualStart = now.subtract(const Duration(days: 1));
    await database.upsertMany([
      GlucoseReading(timestamp: actualStart, value: 6.4),
    ]);
    await database.recordSourceSuccess(
      'nightscout',
      subjectId: GlucoseSubject.selfId,
      coveredFrom: actualStart,
      coveredTo: now,
      syncWindowDays: 30,
    );
    final state = await database.getSourceState('nightscout');

    final plan = await const GlucoseSyncWindowPlanResolver().resolve(
      database: database,
      subjectId: GlucoseSubject.selfId,
      state: state,
      policy: const GlucoseSyncPolicy(initialSyncDays: 30),
      now: now,
    );

    expect(plan, isNull);
  });
}
