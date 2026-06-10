import 'foreground_reconcile_context.dart';
import 'foreground_reconcile_mode.dart';

abstract class ForegroundReconcileStep {
  String get id;

  bool supports(ForegroundReconcileMode mode);

  Future<void> run(ForegroundReconcileContext context);
}
