import '../data_source/data_source_kind.dart';
import 'polling_risk_level.dart';

class PollingDecision {
  final DataSourceKind? sourceKind;
  final Duration nextInterval;
  final PollingRiskLevel riskLevel;
  final String reason;
  final bool shouldSyncNow;

  const PollingDecision({
    required this.nextInterval,
    required this.riskLevel,
    required this.reason,
    this.sourceKind,
    this.shouldSyncNow = true,
  });

  static const disabled = PollingDecision(
    nextInterval: Duration(minutes: 5),
    riskLevel: PollingRiskLevel.normal,
    reason: 'No enabled data source',
    shouldSyncNow: false,
  );
}
