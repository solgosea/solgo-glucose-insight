import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_explanation.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/juggluco/juggluco_path_state.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../engines/juggluco/juggluco_metric_ids.dart';
import '../../engines/juggluco/juggluco_path_state_calculator.dart';
import '../status_metric_rule.dart';

class JugglucoBroadcastFreshnessRule implements StatusMetricRule {
  final JugglucoPathStateCalculator calculator;

  const JugglucoBroadcastFreshnessRule({
    this.calculator = const JugglucoPathStateCalculator(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('juggluco.broadcast_freshness');
    final evidence = context.evidence.jugglucoEvidence;
    final age = evidence.latestXdripCompatibleAge(context.now);
    final state = calculator.calculate(
      receiverConfigured: evidence.receiverConfigured,
      broadcastObserved: evidence.broadcastObserved,
      xdripCompatibleObserved: evidence.hasXdripCompatiblePath,
      age: age,
    );
    final level = _level(state);
    final metric = StatusMetric(
      id: JugglucoMetricIds.freshness,
      label: 'Latest Juggluco broadcast',
      valueLabel: age == null ? _stateLabel(state) : _valueLabel(context),
      level: level,
      source: StatusMetricSource.localProbe,
      observedAt: evidence.latestBroadcastAt,
      note: _note(state),
      metadata: {
        'pathState': state.name,
        'latestPath': evidence.latestPath.name,
        'xdripCompatibleObserved': evidence.hasXdripCompatiblePath,
      },
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: state == JugglucoPathState.notConfigured
          ? StatusDataQuality.unavailable
          : StatusDataQuality.normal,
      explanation: StatusRuleExplanation(
        summary: _stateLabel(state),
        detail: _note(state),
        facts: {'pathState': state.name, 'age': metric.valueLabel},
      ),
      affectsComponentLevel: state != JugglucoPathState.notConfigured,
    );
  }

  String _valueLabel(StatusAnalysisContext context) {
    final evidence = context.evidence.jugglucoEvidence;
    final age = evidence.latestXdripCompatibleAge(context.now);
    final glucose =
        evidence.latestXdripCompatiblePath?.glucose ?? evidence.latestGlucose;
    final unit =
        evidence.latestXdripCompatiblePath?.unit ?? evidence.unit ?? 'mg/dL';
    if (age == null) return _stateLabel(JugglucoPathState.unknown);
    final ageLabel = _age(age);
    if (glucose == null) return ageLabel;
    return '${_formatGlucose(glucose)} $unit - $ageLabel';
  }

  String _formatGlucose(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }

  StatusLevel _level(JugglucoPathState state) {
    return switch (state) {
      JugglucoPathState.fresh => StatusLevel.healthy,
      JugglucoPathState.delayed => StatusLevel.watch,
      JugglucoPathState.stale ||
      JugglucoPathState.unavailable =>
        StatusLevel.issue,
      JugglucoPathState.waitingForFirstBroadcast => StatusLevel.watch,
      JugglucoPathState.directOnly => StatusLevel.watch,
      JugglucoPathState.notConfigured ||
      JugglucoPathState.unknown =>
        StatusLevel.unknown,
    };
  }

  String _stateLabel(JugglucoPathState state) {
    return switch (state) {
      JugglucoPathState.fresh => 'Fresh',
      JugglucoPathState.delayed => 'Delayed',
      JugglucoPathState.stale => 'Stale',
      JugglucoPathState.unavailable => 'Unavailable',
      JugglucoPathState.waitingForFirstBroadcast =>
        'Waiting for first broadcast',
      JugglucoPathState.directOnly => 'Direct broadcast only',
      JugglucoPathState.notConfigured => 'Not configured',
      JugglucoPathState.unknown => 'Unknown',
    };
  }

  String _note(JugglucoPathState state) {
    return switch (state) {
      JugglucoPathState.fresh => 'Juggluco path is flowing.',
      JugglucoPathState.delayed =>
        'Juggluco broadcast is present but slower than expected.',
      JugglucoPathState.stale ||
      JugglucoPathState.unavailable =>
        'Start troubleshooting at Juggluco, Libre, or phone source side.',
      JugglucoPathState.waitingForFirstBroadcast =>
        'Solgo Insight is ready. Wait for Juggluco to publish the first glucose broadcast.',
      JugglucoPathState.directOnly =>
        'Juggluco direct broadcast is visible, but the xDrip-compatible path has not been observed yet.',
      JugglucoPathState.notConfigured =>
        'Juggluco broadcast is not configured or Solgo Insight is not selected as receiver.',
      JugglucoPathState.unknown => 'No reliable Juggluco broadcast state yet.',
    };
  }

  String _age(Duration age) {
    if (age.inMinutes < 1) return '${age.inSeconds}s';
    if (age.inHours < 1) return '${age.inMinutes}m';
    return '${age.inHours}h';
  }
}
