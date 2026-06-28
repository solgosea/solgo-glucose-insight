import '../../../domain/hub/path/status_hub_path_models.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/status_level.dart';

class StatusHubPathMetricBuilder {
  const StatusHubPathMetricBuilder();

  List<StatusHubPathMetric> fromFacts(
    StatusHubConnectionId pathId,
    List<StatusHubMetricFact> facts,
  ) {
    return facts.map((fact) {
      return StatusHubPathMetric(
        id: '${pathId.value}.${_metricId(fact.label)}',
        type: _typeFor(fact.label),
        label: fact.label,
        valueLabel: fact.valueLabel,
        numericValue: _numericValue(fact.valueLabel),
        unit: _unitFor(fact.label),
        state: _stateFor(fact.level.name),
        source: fact.source,
        meaning: _meaningFor(pathId, fact.label),
      );
    }).toList(growable: false);
  }

  StatusHubMetricFact toFact(StatusHubPathMetric metric) {
    return StatusHubMetricFact(
      label: metric.label,
      valueLabel: metric.valueLabel,
      level: _levelFor(metric.state),
      source: metric.source,
    );
  }

  String _metricId(String label) {
    return label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  }

  StatusHubPathMetricType _typeFor(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('reading') ||
        normalized.contains('age') ||
        normalized.contains('broadcast')) {
      return StatusHubPathMetricType.freshness;
    }
    if (normalized.contains('delay') || normalized.contains('local')) {
      return StatusHubPathMetricType.delay;
    }
    if (normalized.contains('coverage') || normalized.contains('continuity')) {
      return StatusHubPathMetricType.coverage;
    }
    if (normalized.contains('handoff') ||
        normalized.contains('format') ||
        normalized.contains('context')) {
      return StatusHubPathMetricType.alignment;
    }
    if (normalized.contains('priority')) {
      return StatusHubPathMetricType.priority;
    }
    return StatusHubPathMetricType.evidence;
  }

  String? _unitFor(String label) {
    final normalized = label.toLowerCase();
    if (normalized.contains('age') ||
        normalized.contains('reading') ||
        normalized.contains('broadcast') ||
        normalized.contains('local')) {
      return 'time';
    }
    if (normalized.contains('coverage')) return '%';
    return null;
  }

  double? _numericValue(String value) {
    final match = RegExp(r'-?\d+(\.\d+)?').firstMatch(value);
    if (match == null) return null;
    return double.tryParse(match.group(0)!);
  }

  StatusHubState _stateFor(String levelName) {
    return switch (levelName) {
      'healthy' => StatusHubState.fresh,
      'watch' => StatusHubState.delayed,
      'issue' => StatusHubState.stale,
      _ => StatusHubState.unknown,
    };
  }

  StatusLevel _levelFor(StatusHubState state) {
    return switch (state) {
      StatusHubState.fresh => StatusLevel.healthy,
      StatusHubState.delayed || StatusHubState.limited => StatusLevel.watch,
      StatusHubState.stale || StatusHubState.unavailable => StatusLevel.issue,
      _ => StatusLevel.unknown,
    };
  }

  String _meaningFor(StatusHubConnectionId pathId, String label) {
    return switch (pathId) {
      StatusHubConnectionId.cgmToXdrip =>
        '$label helps verify whether upstream sensor data reaches xDrip+.',
      StatusHubConnectionId.jugglucoToXdrip =>
        '$label helps verify the Juggluco handoff into xDrip+.',
      StatusHubConnectionId.xdripToNightscout =>
        '$label helps compare local xDrip+ data with Nightscout cloud evidence.',
      StatusHubConnectionId.xdripToAaps =>
        '$label helps verify whether AAPS can observe xDrip+ as a BG source.',
      StatusHubConnectionId.xdripToWatch =>
        '$label is display-only evidence from the xDrip+ side.',
    };
  }
}
