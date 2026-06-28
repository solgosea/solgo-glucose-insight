import '../../shared/status_check_shared_context.dart';

class StatusCheckStepContext {
  final StatusCheckSharedContext shared;
  final DateTime now;

  const StatusCheckStepContext({
    required this.shared,
    required this.now,
  });
}
