import '../detail/status_component_detail_data.dart';
import '../detail/status_signal_summary.dart';
import '../detail/status_timeline_bucket.dart';
import '../nightscout_markers/nightscout_marker_analysis.dart';
import 'xdrip_completeness_bucket.dart';
import 'xdrip_context_signal.dart';
import 'xdrip_health_score_breakdown.dart';
import 'xdrip_local_service_probe.dart';

class XdripDetailData extends StatusComponentDetailData {
  static const typeName = 'xdrip';

  final List<StatusSignalSummary> signals;
  final List<StatusTimelineBucket> freshnessTimeline;
  final List<XdripCompletenessBucket> completenessBuckets;
  final XdripLocalServiceProbe? localService;
  final List<XdripContextSignal> contextSignals;
  final String modeLabel;
  final NightscoutMarkerAnalysis markerAnalysis;
  final XdripHealthScoreBreakdown? scoreBreakdown;

  const XdripDetailData({
    required this.signals,
    required this.freshnessTimeline,
    required this.completenessBuckets,
    required this.contextSignals,
    required this.modeLabel,
    this.markerAnalysis = const NightscoutMarkerAnalysis.empty(),
    this.scoreBreakdown,
    this.localService,
  });

  @override
  String get type => typeName;

  @override
  Map<String, Object?> toJson() => {
        'type': type,
        'signals': signals.map((signal) => signal.toJson()).toList(),
        'freshnessTimeline':
            freshnessTimeline.map((bucket) => bucket.toJson()).toList(),
        'completenessBuckets':
            completenessBuckets.map((bucket) => bucket.toJson()).toList(),
        'localService': localService?.toJson(),
        'contextSignals':
            contextSignals.map((signal) => signal.toJson()).toList(),
        'modeLabel': modeLabel,
        'markerAnalysis': markerAnalysis.toJson(),
        'scoreBreakdown': scoreBreakdown?.toJson(),
      };

  factory XdripDetailData.fromJson(Map<String, Object?> json) {
    return XdripDetailData(
      signals: const [],
      freshnessTimeline: const [],
      completenessBuckets: const [],
      contextSignals: const [],
      modeLabel: json['modeLabel']?.toString() ?? '',
      markerAnalysis: json['markerAnalysis'] is Map
          ? NightscoutMarkerAnalysis.fromJson(
              Map<String, Object?>.from(json['markerAnalysis'] as Map),
            )
          : const NightscoutMarkerAnalysis.empty(),
    );
  }
}
