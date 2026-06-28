import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../models/status_check_lane.dart';
import '../models/status_check_priority.dart';
import 'status_check_step_context.dart';

abstract interface class StatusCheckComponentDefinition {
  StatusComponentKind get kind;
  StatusCheckLane get lane;
  StatusCheckPriority get priority;
  List<StatusComponentKind> get dependencies;
  String get initialStepLabel;
  String get runningStepLabel;

  Future<ComponentHealth> run(StatusCheckStepContext context);
}
