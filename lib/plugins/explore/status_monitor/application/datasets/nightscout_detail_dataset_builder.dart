import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/detail/status_signal_summary.dart';
import '../../domain/nightscout/nightscout_detail_data.dart';
import '../../domain/nightscout/nightscout_health_score_breakdown.dart';
import '../../domain/status_metric.dart';
import '../engines/nightscout/nightscout_capability_context_calculator.dart';
import '../engines/nightscout/nightscout_endpoint_matrix_calculator.dart';
import '../engines/nightscout/nightscout_response_timeline_calculator.dart';
import '../engines/nightscout/nightscout_server_freshness_calculator.dart';
import 'status_dataset_builder.dart';

class NightscoutDetailDatasetBuilder
    implements StatusDatasetBuilder<NightscoutDetailData> {
  final NightscoutEndpointMatrixCalculator endpointMatrixCalculator;
  final NightscoutResponseTimelineCalculator responseTimelineCalculator;
  final NightscoutServerFreshnessCalculator serverFreshnessCalculator;
  final NightscoutCapabilityContextCalculator capabilityContextCalculator;

  const NightscoutDetailDatasetBuilder({
    this.endpointMatrixCalculator = const NightscoutEndpointMatrixCalculator(),
    this.responseTimelineCalculator =
        const NightscoutResponseTimelineCalculator(),
    this.serverFreshnessCalculator =
        const NightscoutServerFreshnessCalculator(),
    this.capabilityContextCalculator =
        const NightscoutCapabilityContextCalculator(),
  });

  @override
  NightscoutDetailData build({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
  }) {
    return buildWithBreakdown(
      context: context,
      metrics: metrics,
    );
  }

  NightscoutDetailData buildWithBreakdown({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
    NightscoutHealthScoreBreakdown? scoreBreakdown,
  }) {
    return NightscoutDetailData(
      signals: _signals(metrics),
      endpointMatrix: endpointMatrixCalculator.calculate(context),
      responseTimeline: responseTimelineCalculator.calculate(context),
      capabilityContext: capabilityContextCalculator.calculate(context),
      latestServerReadingLabel: serverFreshnessCalculator.latestLabel(context),
      versionContextLabel: 'Version context only - not included in score.',
      scoreBreakdown: scoreBreakdown,
    );
  }

  List<StatusSignalSummary> _signals(List<StatusMetric> metrics) {
    return metrics
        .map(
          (metric) => StatusSignalSummary(
            id: metric.id,
            label: metric.label,
            valueLabel: metric.valueLabel,
            level: metric.level,
            note: metric.note ?? metric.unavailableReason,
          ),
        )
        .toList(growable: false);
  }
}
