import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../checking/contracts/status_check_component_definition.dart';
import '../../checking/contracts/status_check_step_context.dart';
import '../../checking/models/status_check_lane.dart';
import '../../checking/models/status_check_priority.dart';
import '../../engines/watch/watch_status_engine.dart';

class WatchCheckDefinition implements StatusCheckComponentDefinition {
  final WatchStatusEngine engine;

  const WatchCheckDefinition({
    this.engine = const WatchStatusEngine(),
  });

  @override
  StatusComponentKind get kind => StatusComponentKind.watchDisplay;

  @override
  StatusCheckLane get lane => StatusCheckLane.dependent;

  @override
  StatusCheckPriority get priority => StatusCheckPriority.dependent;

  @override
  List<StatusComponentKind> get dependencies =>
      const [StatusComponentKind.xdrip];

  @override
  String get initialStepLabel => 'Waiting for xDrip+ display evidence';

  @override
  String get runningStepLabel => 'Checking watch display path';

  @override
  Future<ComponentHealth> run(StatusCheckStepContext context) {
    return engine.evaluate(
      StatusAnalysisContext(
        now: context.now,
        evidence: context.shared.evidence,
        componentEvidence: context.shared.componentEvidence,
      ),
    );
  }
}
