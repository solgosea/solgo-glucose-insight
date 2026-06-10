import 'foreground_reconcile_mode.dart';

class ForegroundReconcileDecision {
  final ForegroundReconcileMode mode;
  final String reason;

  const ForegroundReconcileDecision({required this.mode, required this.reason});

  bool get shouldRun => mode != ForegroundReconcileMode.skip;

  const ForegroundReconcileDecision.skip({
    this.reason = 'Foreground reconcile skipped.',
  }) : mode = ForegroundReconcileMode.skip;

  const ForegroundReconcileDecision.light({required this.reason})
    : mode = ForegroundReconcileMode.light;

  const ForegroundReconcileDecision.full({required this.reason})
    : mode = ForegroundReconcileMode.full;
}
