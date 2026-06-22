import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class UploadLatencyRule implements StatusMetricRule {
  final StatusRuleExplanationTextBuilder textBuilder;

  const UploadLatencyRule({
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const metric = StatusMetric.unknown(
      id: 'upload_latency_p95',
      label: 'P95 upload latency',
      source: StatusMetricSource.entries,
      reason: 'Upload receipt timestamps are not available yet',
    );
    return StatusRuleResult(
      ruleId: const StatusRuleId('xdrip.upload_latency_p95'),
      metric: metric,
      level: StatusLevel.unknown,
      dataQuality: StatusDataQuality.unavailable,
      explanation: textBuilder.build(
        'status.rule.xdrip.upload_latency.unavailable.v1',
        const {},
      ),
      affectsComponentLevel: false,
    );
  }
}
