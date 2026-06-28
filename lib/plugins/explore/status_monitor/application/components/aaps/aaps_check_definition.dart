import '../../checking/contracts/status_check_component_definition.dart';
import '../../checking/contracts/status_check_step_context.dart';
import '../../checking/models/status_check_lane.dart';
import '../../checking/models/status_check_priority.dart';
import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../engines/aaps/aaps_status_engine.dart';

class AapsCheckDefinition implements StatusCheckComponentDefinition {
  final AapsStatusEngine engine;

  const AapsCheckDefinition({
    this.engine = const AapsStatusEngine(),
  });

  @override
  StatusComponentKind get kind => StatusComponentKind.aapsLoop;

  @override
  StatusCheckLane get lane => StatusCheckLane.dependent;

  @override
  StatusCheckPriority get priority => StatusCheckPriority.dependent;

  @override
  List<StatusComponentKind> get dependencies =>
      const [StatusComponentKind.nightscout];

  @override
  String get initialStepLabel => 'Waiting for Nightscout context';

  @override
  String get runningStepLabel => 'Checking AAPS loop context';

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
