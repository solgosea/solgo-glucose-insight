import '../detail/status_component_detail_data.dart';
import '../detail/status_signal_summary.dart';
import 'nightscout_capability_context.dart';
import 'nightscout_endpoint_matrix.dart';
import 'nightscout_health_score_breakdown.dart';
import 'nightscout_response_timeline.dart';

class NightscoutDetailData extends StatusComponentDetailData {
  static const typeName = 'nightscout';

  final List<StatusSignalSummary> signals;
  final NightscoutEndpointMatrix endpointMatrix;
  final NightscoutResponseTimeline responseTimeline;
  final List<NightscoutCapabilityContext> capabilityContext;
  final String latestServerReadingLabel;
  final String versionContextLabel;
  final NightscoutHealthScoreBreakdown? scoreBreakdown;

  const NightscoutDetailData({
    required this.signals,
    required this.endpointMatrix,
    required this.responseTimeline,
    required this.capabilityContext,
    required this.latestServerReadingLabel,
    required this.versionContextLabel,
    this.scoreBreakdown,
  });

  @override
  String get type => typeName;

  @override
  Map<String, Object?> toJson() => {
        'type': type,
        'signals': signals.map((signal) => signal.toJson()).toList(),
        'endpointMatrix': endpointMatrix.toJson(),
        'responseTimeline': responseTimeline.toJson(),
        'capabilityContext':
            capabilityContext.map((context) => context.toJson()).toList(),
        'latestServerReadingLabel': latestServerReadingLabel,
        'versionContextLabel': versionContextLabel,
        'scoreBreakdown': scoreBreakdown?.toJson(),
      };

  factory NightscoutDetailData.fromJson(Map<String, Object?> json) {
    return NightscoutDetailData(
      signals: const [],
      endpointMatrix: const NightscoutEndpointMatrix(endpoints: []),
      responseTimeline: const NightscoutResponseTimeline(points: []),
      capabilityContext: const [],
      latestServerReadingLabel:
          json['latestServerReadingLabel']?.toString() ?? '',
      versionContextLabel: json['versionContextLabel']?.toString() ?? '',
    );
  }
}
