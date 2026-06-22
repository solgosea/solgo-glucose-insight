import '../../domain/component_health.dart';

class StatusWidgetScoreAggregator {
  const StatusWidgetScoreAggregator();

  int? aggregate(List<ComponentHealth> components) {
    final scores = components
        .map((component) => component.score?.value)
        .whereType<int>()
        .toList(growable: false);
    if (scores.isEmpty) return null;
    final sum = scores.reduce((a, b) => a + b);
    return (sum / scores.length).round().clamp(0, 100);
  }
}
