import 'glucose_sync_context.dart';

abstract class GlucoseSyncStep {
  const GlucoseSyncStep();

  Future<void> execute(GlucoseSyncContext context);
}
