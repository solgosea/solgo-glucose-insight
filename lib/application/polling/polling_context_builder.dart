import '../../data/local/glucose_database.dart';
import '../../domain/data_source/data_source_kind.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/source_sync_state.dart';
import '../../domain/polling/polling_context.dart';
import '../../domain/polling/polling_mode.dart';
import '../../domain/subject/glucose_subject.dart';

typedef PollingSourceStateLoader =
    Future<SourceSyncState?> Function(DataSourceKind kind);

class PollingContextBuilder {
  final GlucoseDatabase database;
  final PollingSourceStateLoader sourceStateLoader;

  const PollingContextBuilder({
    required this.database,
    required this.sourceStateLoader,
  });

  Future<PollingContext> build({
    required DataSourceKind sourceKind,
    required PollingMode mode,
    required AppSettings settings,
    DateTime? now,
  }) async {
    final current = now ?? DateTime.now();
    final sourceState = await sourceStateLoader(sourceKind);
    final latest = await database.readings.latest(
      subjectId: GlucoseSubject.selfId,
    );
    return PollingContext(
      sourceKind: sourceKind,
      mode: mode,
      now: current,
      lastSuccessAt: sourceState?.lastSuccessAt,
      lastAttemptAt: sourceState?.lastAttemptAt,
      lastReadingAt: latest?.timestamp,
      latestGlucoseValue: latest?.value,
      latestRatePerMin: latest?.ratePerMin,
      consecutiveFailures: _failureCount(sourceState),
    );
  }

  int _failureCount(SourceSyncState? state) {
    final error = state?.lastError;
    if (error == null || error.trim().isEmpty) return 0;
    return 1;
  }
}
