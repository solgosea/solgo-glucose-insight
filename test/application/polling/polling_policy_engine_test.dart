import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/polling/polling_policy_engine.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/polling/polling_context.dart';
import 'package:smart_xdrip/domain/polling/polling_mode.dart';
import 'package:smart_xdrip/domain/polling/polling_risk_level.dart';

void main() {
  const engine = PollingPolicyEngine();
  final now = DateTime.utc(2026, 1, 1, 8);

  test('xDrip foreground normal uses configured sync interval', () {
    final decision = engine.decide(
      PollingContext(
        sourceKind: DataSourceKind.xdripLocal,
        mode: PollingMode.foreground,
        now: now,
        lastReadingAt: now.subtract(const Duration(minutes: 2)),
        latestGlucoseValue: 6.2,
        normalSyncInterval: const Duration(minutes: 2),
      ),
    );

    expect(decision.nextInterval, const Duration(minutes: 2));
    expect(decision.riskLevel, PollingRiskLevel.normal);
  });

  test('xDrip background normal uses configured sync interval', () {
    final decision = engine.decide(
      PollingContext(
        sourceKind: DataSourceKind.xdripLocal,
        mode: PollingMode.background,
        now: now,
        lastReadingAt: now.subtract(const Duration(minutes: 2)),
        latestGlucoseValue: 6.2,
        normalSyncInterval: const Duration(minutes: 4),
      ),
    );

    expect(decision.nextInterval, const Duration(minutes: 4));
  });

  test('danger glucose accelerates xDrip polling to 30 seconds', () {
    final decision = engine.decide(
      PollingContext(
        sourceKind: DataSourceKind.xdripLocal,
        mode: PollingMode.background,
        now: now,
        lastReadingAt: now.subtract(const Duration(minutes: 1)),
        latestGlucoseValue: 3.4,
      ),
    );

    expect(decision.nextInterval, const Duration(seconds: 30));
    expect(decision.riskLevel, PollingRiskLevel.dangerous);
  });

  test('Nightscout background normal uses configured sync interval', () {
    final decision = engine.decide(
      PollingContext(
        sourceKind: DataSourceKind.nightscout,
        mode: PollingMode.background,
        now: now,
        lastReadingAt: now.subtract(const Duration(minutes: 2)),
        latestGlucoseValue: 6.2,
        normalSyncInterval: const Duration(minutes: 5),
      ),
    );

    expect(decision.nextInterval, const Duration(minutes: 5));
  });

  test('failure backoff grows but is capped by source profile', () {
    final decision = engine.decide(
      PollingContext(
        sourceKind: DataSourceKind.xdripLocal,
        mode: PollingMode.background,
        now: now,
        consecutiveFailures: 5,
      ),
    );

    expect(decision.nextInterval, const Duration(seconds: 300));
    expect(decision.riskLevel, PollingRiskLevel.failing);
  });
}
