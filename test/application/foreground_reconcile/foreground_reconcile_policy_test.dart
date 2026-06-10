import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/foreground_reconcile/foreground_reconcile_context.dart';
import 'package:smart_xdrip/application/foreground_reconcile/foreground_reconcile_mode.dart';
import 'package:smart_xdrip/application/foreground_reconcile/foreground_reconcile_platform.dart';
import 'package:smart_xdrip/application/foreground_reconcile/foreground_reconcile_policy.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

void main() {
  final now = DateTime(2026, 6, 7, 12);
  const policy = ForegroundReconcilePolicy();

  test('skips when foreground reconcile recently completed', () {
    final decision = policy.decide(
      ForegroundReconcileContext(
        settings: const AppSettings(),
        platform: ForegroundReconcilePlatform.ios,
        now: now,
        lastForegroundReconcileAt: now.subtract(const Duration(seconds: 10)),
        hasSyncTargets: true,
      ),
    );

    expect(decision.mode, ForegroundReconcileMode.skip);
    expect(decision.shouldRun, isFalse);
  });

  test('iOS resume always uses full reconcile after debounce window', () {
    final decision = policy.decide(
      ForegroundReconcileContext(
        settings: const AppSettings(),
        platform: ForegroundReconcilePlatform.ios,
        now: now,
        lastForegroundReconcileAt: now.subtract(const Duration(minutes: 1)),
        hasSyncTargets: true,
      ),
    );

    expect(decision.mode, ForegroundReconcileMode.full);
    expect(decision.shouldRun, isTrue);
  });

  test('Android resume uses light reconcile when background sync is fresh', () {
    final decision = policy.decide(
      ForegroundReconcileContext(
        settings: const AppSettings(),
        platform: ForegroundReconcilePlatform.android,
        now: now,
        lastBackgroundSyncAt: now.subtract(const Duration(minutes: 1)),
        lastForegroundReconcileAt: now.subtract(const Duration(minutes: 1)),
        hasSyncTargets: true,
      ),
    );

    expect(decision.mode, ForegroundReconcileMode.light);
    expect(decision.shouldRun, isTrue);
  });

  test('Android resume uses full reconcile when background sync is stale', () {
    final decision = policy.decide(
      ForegroundReconcileContext(
        settings: const AppSettings(),
        platform: ForegroundReconcilePlatform.android,
        now: now,
        lastBackgroundSyncAt: now.subtract(const Duration(minutes: 8)),
        lastForegroundReconcileAt: now.subtract(const Duration(minutes: 1)),
        hasSyncTargets: true,
      ),
    );

    expect(decision.mode, ForegroundReconcileMode.full);
    expect(decision.shouldRun, isTrue);
  });

  test('Android resume without sync targets stays light', () {
    final decision = policy.decide(
      ForegroundReconcileContext(
        settings: const AppSettings(),
        platform: ForegroundReconcilePlatform.android,
        now: now,
        lastBackgroundSyncAt: null,
        lastForegroundReconcileAt: now.subtract(const Duration(minutes: 1)),
        hasSyncTargets: false,
      ),
    );

    expect(decision.mode, ForegroundReconcileMode.light);
  });
}
