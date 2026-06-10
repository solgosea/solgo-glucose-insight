import 'foreground_reconcile_context.dart';
import 'foreground_reconcile_decision.dart';
import 'foreground_reconcile_step_registry.dart';

class ForegroundReconcilePipeline {
  final ForegroundReconcileStepRegistry registry;

  const ForegroundReconcilePipeline({required this.registry});

  Future<void> run({
    required ForegroundReconcileContext context,
    required ForegroundReconcileDecision decision,
  }) async {
    if (!decision.shouldRun) return;
    for (final step in registry.steps) {
      if (!step.supports(decision.mode)) continue;
      try {
        await step.run(context);
      } catch (_) {
        // Foreground reconcile is a recovery pass; one plugin must not block
        // the rest of the app from becoming fresh again.
      }
    }
  }
}
