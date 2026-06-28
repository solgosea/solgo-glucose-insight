import 'status_probe_guide_action_vm.dart';

class StatusProbeResultRowVm {
  final String id;
  final String title;
  final String body;
  final String code;
  final String state;
  final bool yes;
  final bool pending;
  final bool running;
  final bool completed;
  final StatusProbeGuideActionVm? guideAction;

  const StatusProbeResultRowVm({
    required this.id,
    required this.title,
    required this.body,
    required this.code,
    required this.state,
    required this.yes,
    this.pending = false,
    this.running = false,
    this.completed = true,
    this.guideAction,
  });
}
