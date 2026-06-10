import '../foreground_reconcile_context.dart';
import '../foreground_reconcile_mode.dart';
import '../foreground_reconcile_step.dart';

class CallbackForegroundReconcileStep implements ForegroundReconcileStep {
  @override
  final String id;
  final Set<ForegroundReconcileMode> modes;
  final Future<void> Function(ForegroundReconcileContext context) callback;

  const CallbackForegroundReconcileStep({
    required this.id,
    required this.modes,
    required this.callback,
  });

  @override
  bool supports(ForegroundReconcileMode mode) => modes.contains(mode);

  @override
  Future<void> run(ForegroundReconcileContext context) => callback(context);
}
