import '../glucose_sync_context.dart';
import '../glucose_sync_cursor_resolver.dart';
import '../glucose_sync_window_plan_resolver.dart';
import '../glucose_sync_step.dart';

class ResolveSyncPlanStep extends GlucoseSyncStep {
  final GlucoseSyncCursorResolver cursorResolver;
  final GlucoseSyncWindowPlanResolver windowPlanResolver;

  const ResolveSyncPlanStep({
    required this.cursorResolver,
    this.windowPlanResolver = const GlucoseSyncWindowPlanResolver(),
  });

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    context.sourceState = await context.database.getSourceState(
      context.sourceKey,
      subjectId: context.subjectId,
    );
    final explicitPlan = context.explicitPlan;
    if (explicitPlan != null) {
      context.plan = explicitPlan;
      return;
    }
    final now = DateTime.now();
    final windowPlan = await windowPlanResolver.resolve(
      database: context.database,
      subjectId: context.subjectId,
      state: context.sourceState,
      policy: context.policy,
      now: now,
    );
    if (windowPlan != null) {
      context.plan = windowPlan;
      return;
    }
    context.plan = cursorResolver.resolve(
      state: context.sourceState,
      policy: context.policy,
      now: now,
    );
  }
}
