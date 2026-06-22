import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/component_health.dart';
import 'status_component_engine.dart';

class StatusComponentEngineRegistry {
  final List<StatusComponentEngine> engines;

  const StatusComponentEngineRegistry({required this.engines});

  Future<List<ComponentHealth>> evaluateAll(
      StatusAnalysisContext context) async {
    final components = <ComponentHealth>[];
    for (final engine in engines) {
      components.add(await engine.evaluate(context));
    }
    return components;
  }
}
