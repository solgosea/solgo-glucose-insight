import '../glucose_sync_context.dart';
import '../glucose_sync_retry_policy.dart';
import '../glucose_sync_step.dart';
import '../smart/smart_glucose_sync_fetcher.dart';

class FetchGlucoseReadingsStep extends GlucoseSyncStep {
  final GlucoseSyncRetryPolicy retryPolicy;
  final SmartGlucoseSyncFetcher? fetcher;

  const FetchGlucoseReadingsStep({
    required this.retryPolicy,
    this.fetcher,
  });

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    final plan = context.plan;
    if (plan == null) {
      throw StateError('sync_plan_not_resolved');
    }
    final result =
        await (fetcher ?? SmartGlucoseSyncFetcher(retryPolicy: retryPolicy))
            .fetch(
      source: context.source,
      plan: plan,
    );
    context.readings = result.readings;
    context.smartMetrics = result.metrics;
  }
}
