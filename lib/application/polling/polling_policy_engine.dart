import '../../domain/polling/polling_context.dart';
import '../../domain/polling/polling_decision.dart';
import '../../domain/polling/polling_mode.dart';
import '../../domain/polling/polling_risk_level.dart';
import 'polling_backoff_calculator.dart';
import 'polling_profiles.dart';

class PollingPolicyEngine {
  final PollingBackoffCalculator backoffCalculator;
  final double lowThreshold;
  final double rapidFallRate;
  final Duration staleReadingWindow;

  const PollingPolicyEngine({
    this.backoffCalculator = const PollingBackoffCalculator(),
    this.lowThreshold = 3.9,
    this.rapidFallRate = -0.17,
    this.staleReadingWindow = const Duration(minutes: 15),
  });

  PollingDecision decide(PollingContext context) {
    final profile = PollingProfiles.forKind(context.sourceKind);
    if (context.consecutiveFailures > 0) {
      return PollingDecision(
        sourceKind: context.sourceKind,
        nextInterval: backoffCalculator.delay(
          consecutiveFailures: context.consecutiveFailures,
          maxDelay: profile.failureMax,
        ),
        riskLevel: PollingRiskLevel.failing,
        reason: 'Retry backoff after ${context.consecutiveFailures} failure(s)',
      );
    }

    final latestValue = context.latestGlucoseValue;
    final latestRate = context.latestRatePerMin;
    if (context.hasActiveAlert ||
        (latestValue != null && latestValue <= lowThreshold) ||
        (latestRate != null && latestRate <= rapidFallRate)) {
      return PollingDecision(
        sourceKind: context.sourceKind,
        nextInterval: profile.dangerous,
        riskLevel: PollingRiskLevel.dangerous,
        reason: 'Danger-range glucose or active alert',
      );
    }

    final latestAt = context.lastReadingAt;
    if (latestAt == null ||
        context.now.difference(latestAt) >= staleReadingWindow) {
      return PollingDecision(
        sourceKind: context.sourceKind,
        nextInterval: profile.stale,
        riskLevel: PollingRiskLevel.stale,
        reason: 'Latest glucose reading is stale',
      );
    }

    return PollingDecision(
      sourceKind: context.sourceKind,
      nextInterval: context.normalSyncInterval,
      riskLevel: PollingRiskLevel.normal,
      reason: context.mode == PollingMode.foreground
          ? 'Foreground normal polling'
          : 'Background normal polling',
    );
  }
}
