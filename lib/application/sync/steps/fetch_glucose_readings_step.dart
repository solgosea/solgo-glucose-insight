import '../glucose_sync_context.dart';
import '../glucose_sync_retry_policy.dart';
import '../glucose_sync_step.dart';

class FetchGlucoseReadingsStep extends GlucoseSyncStep {
  final GlucoseSyncRetryPolicy retryPolicy;

  const FetchGlucoseReadingsStep({required this.retryPolicy});

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    final plan = context.plan;
    if (plan == null) {
      throw StateError('sync_plan_not_resolved');
    }
    context.readings = await retryPolicy.run(
      () => context.source.range(from: plan.from, to: plan.to),
    );
  }
}
