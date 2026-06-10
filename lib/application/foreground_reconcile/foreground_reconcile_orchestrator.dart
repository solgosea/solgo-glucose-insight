import 'foreground_reconcile_context.dart';
import 'foreground_reconcile_decision.dart';
import 'foreground_reconcile_pipeline.dart';
import 'foreground_reconcile_policy.dart';

class ForegroundReconcileOrchestrator {
  final Future<ForegroundReconcileContext> Function(DateTime? lastCompletedAt)
  loadContext;
  final ForegroundReconcilePolicy policy;
  final ForegroundReconcilePipeline pipeline;

  bool _running = false;
  DateTime? _lastCompletedAt;

  ForegroundReconcileOrchestrator({
    required this.loadContext,
    required this.pipeline,
    this.policy = const ForegroundReconcilePolicy(),
  });

  DateTime? get lastCompletedAt => _lastCompletedAt;

  Future<ForegroundReconcileDecision> run() async {
    if (_running) {
      return const ForegroundReconcileDecision.skip(
        reason: 'Foreground reconcile is already running.',
      );
    }
    _running = true;
    try {
      final context = await loadContext(_lastCompletedAt);
      final decision = policy.decide(context);
      await pipeline.run(context: context, decision: decision);
      if (decision.shouldRun) {
        _lastCompletedAt = context.now;
      }
      return decision;
    } finally {
      _running = false;
    }
  }
}
