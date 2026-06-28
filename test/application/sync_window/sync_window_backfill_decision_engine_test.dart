import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync_window/sync_window_backfill_decision_engine.dart';
import 'package:smart_xdrip/application/sync_window/sync_window_backfill_decision_context.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';
import 'package:smart_xdrip/domain/sync_window/sync_window_coverage.dart';

import '../../_support/fakes/fake_glucose_source.dart';

void main() {
  final now = DateTime(2026, 6, 24, 12);
  final engine = SyncWindowBackfillDecisionEngine.standard();

  SyncWindowBackfillDecisionContext context({
    int previousDays = 30,
    int nextDays = 30,
    DateTime? coveredFrom,
    bool enabled = true,
  }) {
    return SyncWindowBackfillDecisionContext(
      previousSettings: AppSettings(
        nightscoutSyncEnabled: true,
        initialSyncDays: previousDays,
      ),
      nextSettings: AppSettings(
        nightscoutSyncEnabled: true,
        initialSyncDays: nextDays,
      ),
      target: GlucoseSyncTarget(
        targetId: 'self:nightscout',
        subjectId: 'self',
        label: 'Nightscout',
        kind: GlucoseSyncTargetKind.selfNightscout,
        source: FakeGlucoseSource(
          type: DataSource.nightscout,
          readings: const [],
        ),
        enabled: enabled,
      ),
      coverage: SyncWindowCoverage(
        subjectId: 'self',
        sourceKey: 'nightscout',
        coveredFrom: coveredFrom,
      ),
      now: now,
    );
  }

  test('plans same-window backfill when coverage is still short', () {
    final decision = engine.evaluate(
      context(coveredFrom: now.subtract(const Duration(days: 14))),
    );

    expect(decision.shouldBackfill, isTrue);
    expect(decision.reason, 'coverage_gap');
    expect(decision.plan!.from, now.subtract(const Duration(days: 30)));
    expect(decision.plan!.to, now.subtract(const Duration(days: 14)));
  });

  test('plans expanded-window backfill from existing coverage boundary', () {
    final decision = engine.evaluate(
      context(
        previousDays: 14,
        nextDays: 30,
        coveredFrom: now.subtract(const Duration(days: 14)),
      ),
    );

    expect(decision.shouldBackfill, isTrue);
    expect(decision.reason, 'coverage_gap');
    expect(decision.plan!.from, now.subtract(const Duration(days: 30)));
    expect(decision.plan!.to, now.subtract(const Duration(days: 14)));
  });

  test('plans full-window backfill when no local coverage is verified', () {
    final decision = engine.evaluate(context(coveredFrom: null));

    expect(decision.shouldBackfill, isTrue);
    expect(decision.reason, 'missing_coverage');
    expect(decision.plan!.from, now.subtract(const Duration(days: 30)));
    expect(decision.plan!.to, now);
  });

  test('skips when coverage already reaches desired window', () {
    final decision = engine.evaluate(
      context(coveredFrom: now.subtract(const Duration(days: 31))),
    );

    expect(decision.shouldBackfill, isFalse);
    expect(decision.reason, 'coverage_current');
  });

  test('skips disabled targets before coverage checks', () {
    final decision = engine.evaluate(
      context(
        enabled: false,
        coveredFrom: now.subtract(const Duration(days: 14)),
      ),
    );

    expect(decision.shouldBackfill, isFalse);
    expect(decision.reason, 'target_disabled');
  });
}
