import 'glucose_sync_context.dart';
import 'glucose_sync_step.dart';

class GlucoseSyncPipeline {
  final List<GlucoseSyncStep> steps;

  const GlucoseSyncPipeline({required this.steps});

  Future<void> run(GlucoseSyncContext context) async {
    for (final step in steps) {
      if (context.stopped) return;
      await step.execute(context);
    }
  }
}
