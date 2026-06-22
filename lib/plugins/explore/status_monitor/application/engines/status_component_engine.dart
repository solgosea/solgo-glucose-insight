import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/component_health.dart';

abstract interface class StatusComponentEngine {
  Future<ComponentHealth> evaluate(StatusAnalysisContext context);
}
