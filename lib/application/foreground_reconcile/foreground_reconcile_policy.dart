import 'foreground_reconcile_context.dart';
import 'foreground_reconcile_decision.dart';
import 'foreground_reconcile_platform.dart';

class ForegroundReconcilePolicy {
  final Duration minInterval;
  final Duration androidFullAfter;

  const ForegroundReconcilePolicy({
    this.minInterval = const Duration(seconds: 30),
    this.androidFullAfter = const Duration(minutes: 5),
  });

  ForegroundReconcileDecision decide(ForegroundReconcileContext context) {
    final lastForeground = context.lastForegroundReconcileAt;
    if (lastForeground != null &&
        context.now.difference(lastForeground) < minInterval) {
      return const ForegroundReconcileDecision.skip(
        reason: 'Foreground reconcile was recently completed.',
      );
    }

    return switch (context.platform) {
      ForegroundReconcilePlatform.ios => const ForegroundReconcileDecision.full(
        reason: 'iOS foreground resume requires full reconcile.',
      ),
      ForegroundReconcilePlatform.android => _androidDecision(context),
      ForegroundReconcilePlatform.other =>
        const ForegroundReconcileDecision.light(
          reason: 'Foreground resume refreshes runtime state.',
        ),
    };
  }

  ForegroundReconcileDecision _androidDecision(
    ForegroundReconcileContext context,
  ) {
    final lastBackground = context.lastBackgroundSyncAt;
    if (context.hasSyncTargets &&
        (lastBackground == null ||
            context.now.difference(lastBackground) >= androidFullAfter)) {
      return const ForegroundReconcileDecision.full(
        reason: 'Android background sync is stale; running full reconcile.',
      );
    }
    return const ForegroundReconcileDecision.light(
      reason: 'Android foreground resume uses light reconcile.',
    );
  }
}
