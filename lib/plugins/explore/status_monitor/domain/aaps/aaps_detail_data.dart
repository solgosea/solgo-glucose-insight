import '../detail/status_component_detail_data.dart';
import '../detail/status_signal_summary.dart';
import '../status_level.dart';
import '../xdrip/xdrip_broadcast_readiness.dart';
import 'aaps_evidence_matrix_row.dart';
import 'aaps_health_score_breakdown.dart';
import 'aaps_loop_timeline_bucket.dart';

class AapsContextCardData {
  final String label;
  final String value;
  final String body;
  final double fraction;
  final StatusLevel level;

  const AapsContextCardData({
    required this.label,
    required this.value,
    required this.body,
    required this.fraction,
    required this.level,
  });

  Map<String, Object?> toJson() => {
        'label': label,
        'value': value,
        'body': body,
        'fraction': fraction,
        'level': level.name,
      };
}

class AapsDetailData extends StatusComponentDetailData {
  static const typeName = 'aaps';

  final List<StatusSignalSummary> signals;
  final List<AapsLoopTimelineBucket> timeline;
  final List<AapsEvidenceMatrixRow> evidenceMatrix;
  final XdripBroadcastReadiness xdripBgSource;
  final AapsContextCardData loopContext;
  final AapsContextCardData pumpContext;
  final AapsContextCardData iobContext;
  final AapsContextCardData cobContext;
  final AapsContextCardData profileContext;
  final String latestContextLabel;
  final AapsHealthScoreBreakdown? scoreBreakdown;

  const AapsDetailData({
    required this.signals,
    required this.timeline,
    required this.evidenceMatrix,
    required this.xdripBgSource,
    required this.loopContext,
    required this.pumpContext,
    required this.iobContext,
    required this.cobContext,
    required this.profileContext,
    required this.latestContextLabel,
    this.scoreBreakdown,
  });

  @override
  String get type => typeName;

  @override
  Map<String, Object?> toJson() => {
        'type': type,
        'signals': signals.map((signal) => signal.toJson()).toList(),
        'timeline': timeline.map((bucket) => bucket.toJson()).toList(),
        'evidenceMatrix': evidenceMatrix.map((row) => row.toJson()).toList(),
        'xdripBgSource': xdripBgSource.toJson(),
        'loopContext': loopContext.toJson(),
        'pumpContext': pumpContext.toJson(),
        'iobContext': iobContext.toJson(),
        'cobContext': cobContext.toJson(),
        'profileContext': profileContext.toJson(),
        'latestContextLabel': latestContextLabel,
        'scoreBreakdown': scoreBreakdown?.toJson(),
      };
}
