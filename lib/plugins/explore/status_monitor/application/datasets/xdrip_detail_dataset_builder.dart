import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/detail/status_signal_summary.dart';
import '../../domain/status_metric.dart';
import '../../domain/status_level.dart';
import '../../domain/xdrip/xdrip_broadcast_readiness.dart';
import '../../domain/xdrip/xdrip_broadcast_state.dart';
import '../../domain/xdrip/xdrip_detail_data.dart';
import '../../domain/xdrip/xdrip_health_score_breakdown.dart';
import '../../domain/xdrip/xdrip_local_service_probe.dart';
import '../engines/xdrip/xdrip_completeness_heatmap_calculator.dart';
import '../engines/xdrip/xdrip_context_signal_calculator.dart';
import '../engines/xdrip/xdrip_freshness_timeline_calculator.dart';
import '../markers/nightscout_marker_analyzer.dart';
import 'status_dataset_builder.dart';

class XdripDetailDatasetBuilder
    implements StatusDatasetBuilder<XdripDetailData> {
  final XdripFreshnessTimelineCalculator freshnessTimelineCalculator;
  final XdripCompletenessHeatmapCalculator completenessHeatmapCalculator;
  final XdripContextSignalCalculator contextSignalCalculator;
  final NightscoutMarkerAnalyzer markerAnalyzer;

  const XdripDetailDatasetBuilder({
    this.freshnessTimelineCalculator = const XdripFreshnessTimelineCalculator(),
    this.completenessHeatmapCalculator =
        const XdripCompletenessHeatmapCalculator(),
    this.contextSignalCalculator = const XdripContextSignalCalculator(),
    this.markerAnalyzer = const NightscoutMarkerAnalyzer(),
  });

  @override
  XdripDetailData build({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
  }) {
    return buildWithBreakdown(
      context: context,
      metrics: metrics,
    );
  }

  XdripDetailData buildWithBreakdown({
    required StatusAnalysisContext context,
    required List<StatusMetric> metrics,
    XdripHealthScoreBreakdown? scoreBreakdown,
  }) {
    return XdripDetailData(
      signals: _signals(metrics),
      freshnessTimeline: freshnessTimelineCalculator.calculate(context),
      completenessBuckets: completenessHeatmapCalculator.calculate(context),
      localService: _localService(context),
      broadcastReadiness: _broadcastReadiness(context),
      contextSignals: contextSignalCalculator.calculate(context),
      modeLabel: 'Local service - '
          '${context.evidence.xdripLocalEvidence.sourceLabel}; Freshness - '
          '${context.evidence.selection.xdripLiveReadings.sourceLabel}',
      markerAnalysis: markerAnalyzer.analyze(
        context.evidence.nightscoutEvidence,
      ),
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

  XdripLocalServiceProbe? _localService(StatusAnalysisContext context) {
    final evidenceProbe = context.evidence.xdripLocalEvidence.serviceProbe;
    if (evidenceProbe != null) {
      return XdripLocalServiceProbe(
        reachable: evidenceProbe.reachable,
        statusCode: evidenceProbe.statusCode,
        elapsed: evidenceProbe.elapsed,
        level: evidenceProbe.level,
        message: evidenceProbe.message ?? 'Local xDrip+ service checked.',
      );
    }
    return null;
  }

  XdripBroadcastReadiness _broadcastReadiness(StatusAnalysisContext context) {
    final evidence = context.evidence.xdripBroadcastEvidence;
    final state = evidence.state(context.now);
    final level = switch (state) {
      XdripBroadcastState.fresh => StatusLevel.healthy,
      XdripBroadcastState.stale ||
      XdripBroadcastState.missing ||
      XdripBroadcastState.invalid =>
        StatusLevel.issue,
      XdripBroadcastState.unknown => StatusLevel.unknown,
    };
    final glucose = evidence.payload.glucose;
    final unit = evidence.payload.unit ?? 'mg/dL';
    return XdripBroadcastReadiness(
      state: state,
      level: level,
      stateLabel: state.label,
      latestLabel: evidence.latestAgeLabel(context.now),
      payloadLabel: glucose == null ? 'No glucose payload' : '$glucose $unit',
      receiverPackage: 'info.nightscout.androidaps',
      guidance: state == XdripBroadcastState.fresh
          ? 'xDrip+ local broadcast is visible. AAPS can use this path when xDrip+ is selected as BG source.'
          : 'In xDrip+ Inter-app settings, enable Broadcast locally, Send displayed glucose value, Compatible Broadcast, and identify receiver info.nightscout.androidaps.',
    );
  }
}
