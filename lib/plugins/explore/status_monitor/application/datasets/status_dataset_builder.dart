import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/status_metric.dart';

abstract interface class StatusDatasetBuilder<T> {
  T build({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
  });
}
