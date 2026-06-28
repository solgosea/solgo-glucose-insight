import '../../../../domain/component_health.dart';
import '../../../../domain/scoring/status_component_score.dart';
import '../../../../domain/status_component_kind.dart';
import '../../../../domain/status_direction.dart';
import '../../../../domain/status_level.dart';
import '../../../../domain/status_metric.dart';
import '../../../../domain/watch/watch_detail_data.dart';
import '../facts/watch_evidence_bundle.dart';
import '../policies/watch_takeaway_policy.dart';

class WatchComponentHealthBuilder {
  final WatchTakeawayPolicy takeawayPolicy;

  const WatchComponentHealthBuilder({
    this.takeawayPolicy = const WatchTakeawayPolicy(),
  });

  ComponentHealth build({
    required WatchEvidenceBundle bundle,
    required StatusLevel level,
    required StatusComponentScore score,
    required List<StatusMetric> metrics,
    required List<StatusDirection> directions,
    required WatchDetailData detailData,
  }) {
    return ComponentHealth(
      kind: StatusComponentKind.watchDisplay,
      level: bundle.evidenceFacts.isEmpty ? StatusLevel.unknown : level,
      title: StatusComponentKind.watchDisplay.title,
      role: StatusComponentKind.watchDisplay.role,
      takeaway: takeawayPolicy.takeaway(level: level, bundle: bundle),
      summary: takeawayPolicy.summary(level: level, bundle: bundle),
      metrics: metrics,
      directions: directions,
      score: score,
      detailData: detailData,
    );
  }
}
