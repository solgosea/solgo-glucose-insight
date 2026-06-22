import '../status_metric.dart';
import 'status_data_quality.dart';
import 'status_rule_explanation.dart';

class StatusMetricResult {
  final StatusMetric metric;
  final StatusDataQuality dataQuality;
  final StatusRuleExplanation explanation;

  const StatusMetricResult({
    required this.metric,
    required this.dataQuality,
    required this.explanation,
  });
}
