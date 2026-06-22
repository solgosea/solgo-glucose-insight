import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/cgm_sensor/cgm_sensor_pipeline_gate_result.dart';
import 'cgm_sensor_metric_ids.dart';

class CgmSensorPipelineGatePolicy {
  const CgmSensorPipelineGatePolicy();

  CgmSensorPipelineGateResult evaluate(
    StatusAnalysisContext context,
    List<StatusRuleResult> results,
  ) {
    final live = context.evidence.selection.cgmLiveReadings;
    if (live.readings.isEmpty) {
      return const CgmSensorPipelineGateResult(
        hasLiveReadings: false,
        maxScore: 0,
        forcedLevel: StatusLevel.unknown,
        message:
            'No live CGM readings are visible. Cached history is only used for detail analysis.',
      );
    }

    final freshness = _metricLevel(results, CgmSensorMetricIds.sensorFreshness);
    if (freshness == StatusLevel.issue) {
      return const CgmSensorPipelineGateResult(
        hasLiveReadings: true,
        maxScore: 45,
        maxLevel: StatusLevel.watch,
        message:
            'Live CGM readings are stale. Historical quality cannot promote the current state to Healthy.',
      );
    }
    if (freshness == StatusLevel.watch) {
      return const CgmSensorPipelineGateResult(
        hasLiveReadings: true,
        maxScore: 75,
        maxLevel: StatusLevel.watch,
        message:
            'Live CGM readings need attention. Historical quality is shown separately.',
      );
    }

    return const CgmSensorPipelineGateResult(
      hasLiveReadings: true,
      message:
          'Live CGM readings are visible. Current status is based on freshness and continuity.',
    );
  }

  StatusLevel _metricLevel(List<StatusRuleResult> results, String metricId) {
    for (final result in results) {
      if (result.metric.id == metricId) return result.level;
    }
    return StatusLevel.unknown;
  }
}
