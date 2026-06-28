import '../../checking/contracts/status_check_component_definition.dart';
import '../../checking/contracts/status_check_step_context.dart';
import '../../checking/models/status_check_lane.dart';
import '../../checking/models/status_check_priority.dart';
import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../engines/nightscout/nightscout_status_engine.dart';

class NightscoutCheckDefinition implements StatusCheckComponentDefinition {
  final NightscoutStatusEngine engine;

  const NightscoutCheckDefinition({
    this.engine = const NightscoutStatusEngine(),
  });

  @override
  StatusComponentKind get kind => StatusComponentKind.nightscout;

  @override
  StatusCheckLane get lane => StatusCheckLane.network;

  @override
  StatusCheckPriority get priority => StatusCheckPriority.normal;

  @override
  List<StatusComponentKind> get dependencies => const [];

  @override
  String get initialStepLabel => 'Queued for Nightscout endpoint checks';

  @override
  String get runningStepLabel => 'Checking Nightscout endpoints';

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
