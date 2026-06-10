import '../glucose_sync_context.dart';
import '../glucose_sync_cursor_resolver.dart';
import '../glucose_sync_step.dart';

class ResolveSyncPlanStep extends GlucoseSyncStep {
  final GlucoseSyncCursorResolver cursorResolver;

  const ResolveSyncPlanStep({required this.cursorResolver});

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    context.sourceState = await context.database.getSourceState(
      context.sourceKey,
      subjectId: context.subjectId,
    );
    context.plan = cursorResolver.resolve(
      state: context.sourceState,
      policy: context.policy,
    );
  }
}
