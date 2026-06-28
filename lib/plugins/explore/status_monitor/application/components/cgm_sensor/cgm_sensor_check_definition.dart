import '../../checking/contracts/status_check_component_definition.dart';
import '../../checking/contracts/status_check_step_context.dart';
import '../../checking/models/status_check_lane.dart';
import '../../checking/models/status_check_priority.dart';
import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../engines/cgm_sensor/cgm_sensor_status_engine.dart';

class CgmSensorCheckDefinition implements StatusCheckComponentDefinition {
  final CgmSensorStatusEngine engine;

  const CgmSensorCheckDefinition({
    this.engine = const CgmSensorStatusEngine(),
  });

  @override
  StatusComponentKind get kind => StatusComponentKind.cgmSensor;

  @override
  StatusCheckLane get lane => StatusCheckLane.local;

  @override
  StatusCheckPriority get priority => StatusCheckPriority.fast;

  @override
  List<StatusComponentKind> get dependencies => const [];

  @override
  String get initialStepLabel => 'Queued for local CGM checks';

  @override
  String get runningStepLabel => 'Checking CGM freshness and continuity';

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
