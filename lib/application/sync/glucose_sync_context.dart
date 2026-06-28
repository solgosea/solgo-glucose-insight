import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';
import 'package:smart_xdrip/domain/glucose_etl/glucose_etl_result.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import 'glucose_sync_plan.dart';
import 'glucose_sync_policy.dart';
import 'glucose_sync_result.dart';
import '../sync_scheduler/limiters/glucose_sync_persistence_limiter.dart';
import 'smart/smart_glucose_sync_metrics.dart';

class GlucoseSyncContext {
  final GlucoseDatabase database;
  final IGlucoseSource source;
  final AppSettings settings;
  final String subjectId;
  final GlucoseSyncPolicy policy;
  final GlucoseSyncPersistenceLimiter? persistenceLimiter;
  final GlucoseSyncPlan? explicitPlan;

  SourceSyncState? sourceState;
  GlucoseSyncPlan? plan;
  List<GlucoseReading> readings = const [];
  SmartGlucoseSyncMetrics? smartMetrics;
  GlucoseEtlResult? etlResult;
  GlucoseSyncResult? result;

  GlucoseSyncContext({
    required this.database,
    required this.source,
    required this.settings,
    this.subjectId = GlucoseSubject.selfId,
    this.persistenceLimiter,
    this.explicitPlan,
  }) : policy = GlucoseSyncPolicy.fromSettings(
          initialSyncDays: settings.initialSyncDays,
        );

  Future<T> runPersistence<T>(Future<T> Function() action) {
    final limiter = persistenceLimiter;
    if (limiter == null) return action();
    return limiter.run(action);
  }

  String get sourceKey => source.type.name;
  bool get stopped => result != null;

  void stopWith(GlucoseSyncResult value) {
    result = value;
  }
}
