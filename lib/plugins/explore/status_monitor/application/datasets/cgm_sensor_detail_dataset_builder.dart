import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/cgm_sensor/cgm_sensor_detail_data.dart';
import '../../domain/cgm_sensor/cgm_sensor_health_score_breakdown.dart';
import '../../domain/detail/status_signal_summary.dart';
import '../../domain/status_level.dart';
import '../../domain/status_metric.dart';
import '../engines/cgm_sensor/cgm_flat_period_calculator.dart';
import '../engines/cgm_sensor/cgm_flat_timeline_dataset_builder.dart';
import '../engines/cgm_sensor/cgm_jump_timeline_dataset_builder.dart';
import '../engines/cgm_sensor/cgm_quality_timeline_calculator.dart';
import '../engines/cgm_sensor/cgm_sudden_jump_calculator.dart';
import 'status_dataset_builder.dart';

class CgmSensorDetailDatasetBuilder
    implements StatusDatasetBuilder<CgmSensorDetailData> {
  final CgmQualityTimelineCalculator qualityTimelineCalculator;
  final CgmSuddenJumpCalculator suddenJumpCalculator;
  final CgmFlatPeriodCalculator flatPeriodCalculator;
  final CgmJumpTimelineDatasetBuilder jumpTimelineDatasetBuilder;
  final CgmFlatTimelineDatasetBuilder flatTimelineDatasetBuilder;

  const CgmSensorDetailDatasetBuilder({
    this.qualityTimelineCalculator = const CgmQualityTimelineCalculator(),
    this.suddenJumpCalculator = const CgmSuddenJumpCalculator(),
    this.flatPeriodCalculator = const CgmFlatPeriodCalculator(),
    this.jumpTimelineDatasetBuilder = const CgmJumpTimelineDatasetBuilder(),
    this.flatTimelineDatasetBuilder = const CgmFlatTimelineDatasetBuilder(),
  });

  @override
  CgmSensorDetailData build({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
  }) {
    return buildWithBreakdown(
      context: context,
      metrics: metrics,
    );
  }

  CgmSensorDetailData buildWithBreakdown({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
    CgmSensorHealthScoreBreakdown? scoreBreakdown,
  }) {
    final suddenJumps = suddenJumpCalculator.calculate(context);
    final flatPeriods = flatPeriodCalculator.calculate(context);
    final latest = _latestReadingInfo(context);
    return CgmSensorDetailData(
      signals: _signals(metrics),
      qualityTimeline: qualityTimelineCalculator.calculate(context),
      latestReadingAgeLabel: latest.label,
      latestReadingLevel: latest.level,
      qualityTimelineSourceLabel:
          context.evidence.selection.cgmHistoryReadings.sourceLabel,
      suddenJumps: suddenJumps,
      jumpTimeline: jumpTimelineDatasetBuilder.build(
        context: context,
        events: suddenJumps,
      ),
      flatPeriods: flatPeriods,
      flatTimeline: flatTimelineDatasetBuilder.build(
        context: context,
        periods: flatPeriods,
      ),
      sourceModeLabel:
          '${context.evidence.selection.cgmLiveReadings.sourceLabel} - history ${context.evidence.selection.cgmHistoryReadings.sourceLabel}',
      contextLabel: context.evidence.xdripLocalEvidence.sensorContext == null
          ? 'Session context is not exposed by this source.'
          : 'Sensor context is available.',
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

  _LatestReadingInfo _latestReadingInfo(StatusAnalysisContext context) {
    final live = context.evidence.selection.cgmLiveReadings.readings;
    final history = context.evidence.selection.cgmHistoryReadings.readings;
    final readings = live.isNotEmpty ? live : history;
    if (readings.isEmpty) {
      return const _LatestReadingInfo('Unknown', StatusLevel.unknown);
    }
    final latest = readings.reduce(
      (a, b) => a.timestamp.isAfter(b.timestamp) ? a : b,
    );
    final age = context.now.difference(latest.timestamp);
    if (age.isNegative) {
      return const _LatestReadingInfo('ahead', StatusLevel.watch);
    }
    final level = age <= const Duration(minutes: 15)
        ? StatusLevel.healthy
        : age <= const Duration(minutes: 30)
            ? StatusLevel.watch
            : StatusLevel.issue;
    return _LatestReadingInfo(_ageLabel(age), level);
  }

  String _ageLabel(Duration age) {
    if (age.inMinutes < 1) return '${age.inSeconds.clamp(0, 59)}s';
    if (age.inHours < 1) return '${age.inMinutes}m';
    if (age.inDays < 1) return '${age.inHours}h';
    return '${age.inDays}d';
  }
}

class _LatestReadingInfo {
  final String label;
  final StatusLevel level;

  const _LatestReadingInfo(this.label, this.level);
}
