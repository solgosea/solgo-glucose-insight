import '../../../domain/hub/path/status_hub_connection_metric_requirement.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/status_level.dart';
import 'status_hub_metric_normalizer.dart';

class StatusHubConnectionMetricFactory {
  final StatusHubMetricNormalizer normalizer;

  const StatusHubConnectionMetricFactory({
    this.normalizer = const StatusHubMetricNormalizer(),
  });

  StatusHubMetricFact age({
    required String id,
    required String label,
    required Duration? age,
    required StatusHubSourceRef source,
    String targetLabel = '<= 6m',
    StatusHubConnectionMetricRequirement requirement =
        StatusHubConnectionMetricRequirement.required,
    String? meaning,
  }) {
    final quant = normalizer.age(age);
    return metric(
      id: id,
      label: label,
      valueLabel: _ageLabel(age),
      numericValue: age?.inSeconds.toDouble(),
      unit: 's',
      targetLabel: targetLabel,
      quantification: quant,
      source: source,
      requirement: requirement,
      meaning: meaning,
    );
  }

  StatusHubMetricFact delay({
    required String id,
    required String label,
    required Duration? delay,
    required StatusHubSourceRef source,
    String targetLabel = '<= 3m',
    StatusHubConnectionMetricRequirement requirement =
        StatusHubConnectionMetricRequirement.required,
    String? meaning,
  }) {
    final quant = normalizer.delay(delay);
    return metric(
      id: id,
      label: label,
      valueLabel: _delayLabel(delay),
      numericValue: delay?.inSeconds.toDouble(),
      unit: 's',
      targetLabel: targetLabel,
      quantification: quant,
      source: source,
      requirement: requirement,
      meaning: meaning,
    );
  }

  StatusHubMetricFact responseMs({
    required String id,
    required String label,
    required int? value,
    required StatusHubSourceRef source,
    String targetLabel = '< 800ms',
    StatusHubConnectionMetricRequirement requirement =
        StatusHubConnectionMetricRequirement.required,
    String? meaning,
  }) {
    final quant = normalizer.responseMs(value);
    return metric(
      id: id,
      label: label,
      valueLabel: value == null ? 'Unknown' : '${value}ms',
      numericValue: value?.toDouble(),
      unit: 'ms',
      targetLabel: targetLabel,
      quantification: quant,
      source: source,
      requirement: requirement,
      meaning: meaning,
    );
  }

  StatusHubMetricFact yesNo({
    required String id,
    required String label,
    required bool observed,
    required StatusHubSourceRef source,
    String targetLabel = 'Yes',
    bool partial = false,
    StatusHubConnectionMetricRequirement requirement =
        StatusHubConnectionMetricRequirement.required,
    String? valueOverride,
    String? meaning,
  }) {
    final quant = normalizer.boolean(observed, partial: partial);
    return metric(
      id: id,
      label: label,
      valueLabel: valueOverride ?? (observed ? 'Yes' : 'No'),
      numericValue: observed ? 1 : 0,
      unit: null,
      targetLabel: targetLabel,
      quantification: quant,
      source: source,
      requirement: requirement,
      meaning: meaning,
    );
  }

  StatusHubMetricFact ratio({
    required String id,
    required String label,
    required int available,
    required int expected,
    required StatusHubSourceRef source,
    String? targetLabel,
    StatusHubConnectionMetricRequirement requirement =
        StatusHubConnectionMetricRequirement.required,
    String? meaning,
  }) {
    final quant = normalizer.ratio(available, expected);
    return metric(
      id: id,
      label: label,
      valueLabel: expected <= 0 ? 'Unknown' : '$available/$expected',
      numericValue:
          expected <= 0 ? null : (available / expected).clamp(0, 1).toDouble(),
      unit: 'ratio',
      targetLabel: targetLabel ?? 'all required',
      quantification: quant,
      source: source,
      requirement: requirement,
      meaning: meaning,
    );
  }

  StatusHubMetricFact unavailable({
    required String id,
    required String label,
    required String targetLabel,
    String valueLabel = 'Unknown',
    String? meaning,
  }) {
    return metric(
      id: id,
      label: label,
      valueLabel: valueLabel,
      numericValue: null,
      unit: null,
      targetLabel: targetLabel,
      quantification: normalizer.unknown(),
      source: const StatusHubSourceRef.unavailable(),
      requirement: StatusHubConnectionMetricRequirement.unavailable,
      meaning: meaning,
    );
  }

  StatusHubMetricFact metric({
    required String id,
    required String label,
    required String valueLabel,
    required double? numericValue,
    required String? unit,
    required String targetLabel,
    required StatusHubMetricQuantification quantification,
    required StatusHubSourceRef source,
    required StatusHubConnectionMetricRequirement requirement,
    String? meaning,
  }) {
    return StatusHubMetricFact(
      id: id,
      label: label,
      valueLabel: valueLabel,
      level: _levelForState(quantification.state),
      source: source,
      numericValue: numericValue,
      unit: unit,
      targetLabel: targetLabel,
      normalizedScore: quantification.score,
      stars: quantification.stars,
      metricState: quantification.state,
      requirement: requirement,
      meaning: meaning,
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

  String _ageLabel(Duration? age) {
    if (age == null) return 'Unknown';
    if (age.inMinutes < 1) return 'just now';
    if (age.inHours < 1) return '${age.inMinutes}m';
    if (age.inDays < 1) return '${age.inHours}h';
    return '${age.inDays}d';
  }

  String _delayLabel(Duration? delay) {
    if (delay == null) return 'Unknown';
    if (delay.isNegative) return 'target newer';
    if (delay.inMinutes.abs() < 1) return 'aligned';
    if (delay.inHours.abs() < 1) return '+${delay.inMinutes.abs()}m';
    return '+${delay.inHours.abs()}h';
  }
}
