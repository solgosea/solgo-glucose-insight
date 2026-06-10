import 'foreground_reconcile_step.dart';

class ForegroundReconcileStepRegistry {
  final List<ForegroundReconcileStep> _steps;

  ForegroundReconcileStepRegistry({
    Iterable<ForegroundReconcileStep> steps = const [],
  }) : _steps = List.of(steps);

  void register(ForegroundReconcileStep step) {
    if (_steps.any((item) => item.id == step.id)) return;
    _steps.add(step);
  }

  List<ForegroundReconcileStep> get steps => List.unmodifiable(_steps);
}
