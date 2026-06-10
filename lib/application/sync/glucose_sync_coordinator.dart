import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import 'glucose_sync_context.dart';
import 'glucose_sync_cursor_resolver.dart';
import 'glucose_sync_error_classifier.dart';
import 'glucose_sync_pipeline.dart';
import 'glucose_sync_result.dart';
import 'glucose_sync_retry_policy.dart';
import 'steps/check_source_availability_step.dart';
import 'steps/fetch_glucose_readings_step.dart';
import 'steps/persist_glucose_readings_step.dart';
import 'steps/record_sync_attempt_step.dart';
import 'steps/record_sync_failure_step.dart';
import 'steps/record_sync_success_step.dart';
import 'steps/resolve_sync_plan_step.dart';
import 'steps/trim_retention_data_step.dart';

class GlucoseSyncCoordinator {
  final GlucoseDatabase database;
  final GlucoseSyncCursorResolver cursorResolver;
  final GlucoseSyncRetryPolicy retryPolicy;
  final GlucoseSyncErrorClassifier errorClassifier;

  const GlucoseSyncCoordinator({
    required this.database,
    this.cursorResolver = const GlucoseSyncCursorResolver(),
    this.retryPolicy = const GlucoseSyncRetryPolicy(),
    this.errorClassifier = const GlucoseSyncErrorClassifier(),
  });

  Future<GlucoseSyncResult> syncOnce({
    required IGlucoseSource source,
    required AppSettings settings,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final context = GlucoseSyncContext(
      database: database,
      source: source,
      settings: settings,
      subjectId: subjectId,
    );
    try {
      await _pipeline().run(context);
      return context.result ??
          GlucoseSyncResult.failure(
            source: source.type,
            subjectId: subjectId,
            error: 'sync_pipeline_no_result',
          );
    } catch (error) {
      return RecordSyncFailureStep(
        errorClassifier: errorClassifier,
      ).execute(context, error);
    }
  }

  GlucoseSyncPipeline _pipeline() {
    return GlucoseSyncPipeline(
      steps: [
        const RecordSyncAttemptStep(),
        CheckSourceAvailabilityStep(retryPolicy: retryPolicy),
        ResolveSyncPlanStep(cursorResolver: cursorResolver),
        FetchGlucoseReadingsStep(retryPolicy: retryPolicy),
        const PersistGlucoseReadingsStep(),
        const TrimRetentionDataStep(),
        const RecordSyncSuccessStep(),
      ],
    );
  }
}
