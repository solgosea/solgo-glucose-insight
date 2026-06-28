import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../status_component_engine.dart';
import 'builders/watch_component_health_builder.dart';
import 'builders/watch_detail_data_builder.dart';
import 'builders/watch_metric_builder.dart';
import 'facts/watch_evidence_bundle_builder.dart';
import 'policies/watch_direction_policy.dart';
import 'policies/watch_path_health_policy.dart';
import 'policies/watch_score_policy.dart';
import 'watch_status_engine_input.dart';
import 'watch_status_engine_output.dart';

class WatchStatusEngine implements StatusComponentEngine {
  final WatchEvidenceBundleBuilder bundleBuilder;
  final WatchPathHealthPolicy pathHealthPolicy;
  final WatchScorePolicy scorePolicy;
  final WatchMetricBuilder metricBuilder;
  final WatchDirectionPolicy directionPolicy;
  final WatchDetailDataBuilder detailDataBuilder;
  final WatchComponentHealthBuilder healthBuilder;

  const WatchStatusEngine({
    this.bundleBuilder = const WatchEvidenceBundleBuilder(),
    this.pathHealthPolicy = const WatchPathHealthPolicy(),
    this.scorePolicy = const WatchScorePolicy(),
    this.metricBuilder = const WatchMetricBuilder(),
    this.directionPolicy = const WatchDirectionPolicy(),
    this.detailDataBuilder = const WatchDetailDataBuilder(),
    this.healthBuilder = const WatchComponentHealthBuilder(),
  });

  @override
  Future<ComponentHealth> evaluate(StatusAnalysisContext context) async {
    return run(WatchStatusEngineInput(context: context)).health;
  }

  WatchStatusEngineOutput run(WatchStatusEngineInput input) {
    final snapshot = input.context.componentEvidence?.snapshot(
      StatusComponentKind.watchDisplay,
    );
    final bundle = bundleBuilder.build(snapshot);
    final level = pathHealthPolicy.level(bundle);
    final score = scorePolicy.score(bundle: bundle, level: level);
    final metrics = metricBuilder.build(bundle);
    final detailData = detailDataBuilder.build(
      bundle: bundle,
      level: level,
      score: score,
    );
    final health = healthBuilder.build(
      bundle: bundle,
      level: level,
      score: score,
      metrics: metrics,
      directions: directionPolicy.directions(level),
      detailData: detailData,
    );
    return WatchStatusEngineOutput(bundle: bundle, health: health);
  }
}
