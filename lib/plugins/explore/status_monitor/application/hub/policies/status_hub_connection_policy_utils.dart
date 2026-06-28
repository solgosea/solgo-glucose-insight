import '../../../domain/hub/facts/status_hub_component_facts.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/status_level.dart';
import 'status_hub_delay_policy.dart';

class StatusHubConnectionPolicyUtils {
  final StatusHubDelayPolicy delayPolicy;

  const StatusHubConnectionPolicyUtils({
    this.delayPolicy = const StatusHubDelayPolicy(),
  });

  Duration? delay(
      StatusHubComponentFacts source, StatusHubComponentFacts target) {
    return delayPolicy.delayVsSource(
      sourceAge: source.age,
      targetAge: target.age,
    );
  }

  StatusHubState freshnessConnectionState(
    StatusHubComponentFacts source,
    StatusHubComponentFacts target,
  ) {
    return delayPolicy.evaluate(
      sourceState: source.state,
      targetState: target.state,
      delayVsSource: delay(source, target),
    );
  }

  double confidence(
      StatusHubComponentFacts source, StatusHubComponentFacts target) {
    return ((source.confidence + target.confidence) / 2).clamp(0, 1);
  }

  List<StatusHubEvidenceRef> evidence(
    StatusHubComponentFacts source,
    StatusHubComponentFacts target,
  ) {
    return [...source.evidence.take(2), ...target.evidence.take(2)];
  }

  List<StatusHubMetricFact> connectionMetrics({
    required StatusHubComponentFacts source,
    required StatusHubComponentFacts target,
    required Duration? delay,
    required double confidence,
    required String policyId,
    String sourceLabel = 'Source',
    String targetLabel = 'Target',
  }) {
    return [
      StatusHubMetricFact(
        label: sourceLabel,
        valueLabel: ageLabel(source.age),
        level: _levelForState(source.state),
        source: _componentSource(source),
        targetLabel: '<= 6m',
        normalizedScore: _scoreForState(source.state),
        stars: _stars(_scoreForState(source.state)),
        metricState: source.state,
        meaning: 'How fresh the upstream evidence is.',
      ),
      StatusHubMetricFact(
        label: targetLabel,
        valueLabel: ageLabel(target.age),
        level: _levelForState(target.state),
        source: _componentSource(target),
        targetLabel: '<= 6m',
        normalizedScore: _scoreForState(target.state),
        stars: _stars(_scoreForState(target.state)),
        metricState: target.state,
        meaning: 'How fresh the downstream evidence is.',
      ),
      StatusHubMetricFact(
        label: 'Delay',
        valueLabel: delayLabel(delay),
        level: _levelForDelay(delay, source, target),
        source: StatusHubSourceRef.derivedPolicy(policyId),
        targetLabel: '< 5m',
        normalizedScore: _scoreForDelay(delay, source, target),
        stars: _stars(_scoreForDelay(delay, source, target)),
        metricState: _stateForLevel(_levelForDelay(delay, source, target)),
        meaning: 'Difference between source and target freshness.',
      ),
      StatusHubMetricFact(
        label: 'Evidence',
        valueLabel: '${(confidence * 100).round()}%',
        level: confidence >= .72
            ? StatusLevel.healthy
            : confidence >= .38
                ? StatusLevel.watch
                : StatusLevel.issue,
        source: StatusHubSourceRef.derivedPolicy('$policyId.confidence'),
        targetLabel: '>= 72%',
        normalizedScore: confidence.clamp(0, 1),
        stars: _stars(confidence.clamp(0, 1)),
        metricState: confidence >= .72
            ? StatusHubState.fresh
            : confidence >= .38
                ? StatusHubState.limited
                : StatusHubState.unavailable,
        meaning: 'How much observable evidence exists for this path.',
      ),
    ];
  }

  StatusHubMetricFact metricFromEvidence({
    required StatusHubComponentFacts component,
    required String id,
    required String label,
    String unavailableValue = 'Unknown',
  }) {
    for (final evidence in component.evidence) {
      if (evidence.id == id) {
        return StatusHubMetricFact(
          label: label,
          valueLabel: evidence.valueLabel,
          level: evidence.level,
          source: evidence.source,
        );
      }
    }
    return StatusHubMetricFact(
      label: label,
      valueLabel: unavailableValue,
      level: StatusLevel.unknown,
      source: const StatusHubSourceRef.unavailable(),
    );
  }

  StatusHubMetricFact detailMetric({
    required String label,
    required String value,
    required StatusLevel level,
    required StatusHubSourceRef source,
  }) {
    return StatusHubMetricFact(
      label: label,
      valueLabel: value.isEmpty ? 'Unknown' : value,
      level: level,
      source: value.isEmpty ? const StatusHubSourceRef.unavailable() : source,
    );
  }

  bool freshish(StatusHubState state) {
    return state == StatusHubState.fresh || state == StatusHubState.delayed;
  }

  String ageLabel(Duration? age) {
    if (age == null) return 'Unknown';
    if (age.inMinutes < 1) return 'just now';
    if (age.inHours < 1) return '${age.inMinutes}m';
    if (age.inDays < 1) return '${age.inHours}h';
    return '${age.inDays}d';
  }

  String delayLabel(Duration? delay) {
    if (delay == null) return 'Unknown';
    if (delay.isNegative) return 'target newer';
    if (delay.inMinutes < 1) return 'aligned';
    if (delay.inHours < 1) return '+${delay.inMinutes}m';
    return '+${delay.inHours}h';
  }

  StatusHubSourceRef _componentSource(StatusHubComponentFacts facts) {
    for (final item in facts.evidence) {
      if (item.source.available) return item.source;
    }
    return StatusHubSourceRef.probeEvidence(
      probeId: 'suite.${facts.kind.queryValue}',
      available: facts.state != StatusHubState.unavailable,
    );
  }

  StatusLevel _levelForState(StatusHubState state) {
    return switch (state) {
      StatusHubState.fresh => StatusLevel.healthy,
      StatusHubState.delayed || StatusHubState.limited => StatusLevel.watch,
      StatusHubState.stale || StatusHubState.unavailable => StatusLevel.issue,
      _ => StatusLevel.unknown,
    };
  }

  double _scoreForState(StatusHubState state) {
    return switch (state) {
      StatusHubState.fresh => 1,
      StatusHubState.delayed => .72,
      StatusHubState.limited => .52,
      StatusHubState.stale => .22,
      StatusHubState.unavailable => 0,
      StatusHubState.notChecked || StatusHubState.unknown => .18,
    };
  }

  double _scoreForDelay(
    Duration? delay,
    StatusHubComponentFacts source,
    StatusHubComponentFacts target,
  ) {
    final level = _levelForDelay(delay, source, target);
    return switch (level) {
      StatusLevel.healthy => 1,
      StatusLevel.watch => .62,
      StatusLevel.issue => .18,
      StatusLevel.unknown => .18,
    };
  }

  int _stars(double score) {
    if (score >= .90) return 5;
    if (score >= .70) return 4;
    if (score >= .50) return 3;
    if (score > .20) return 2;
    if (score > 0) return 1;
    return 0;
  }

  StatusHubState _stateForLevel(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => StatusHubState.fresh,
      StatusLevel.watch => StatusHubState.limited,
      StatusLevel.issue => StatusHubState.unavailable,
      StatusLevel.unknown => StatusHubState.unknown,
    };
  }

  StatusLevel _levelForDelay(
    Duration? delay,
    StatusHubComponentFacts source,
    StatusHubComponentFacts target,
  ) {
    if (delay == null) return StatusLevel.unknown;
    if (delay.isNegative || delay.inMinutes < 5) return StatusLevel.healthy;
    if (delay.inMinutes < 20 &&
        freshish(source.state) &&
        freshish(target.state)) {
      return StatusLevel.watch;
    }
    return StatusLevel.issue;
  }
}
