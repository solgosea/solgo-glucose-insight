import '../../data/local/glucose_database.dart';
import '../../domain/analysis/analysis_snapshot.dart';
import '../../domain/analysis/analysis_module_code.dart';
import '../../domain/analysis/period_glucose_summary.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/subject/analysis_subject.dart';
import '../../domain/subject/glucose_subject.dart';
import 'analysis_refresh_result.dart';
import 'analysis_session_store.dart';

class RestoreAnalysisSessionUseCase {
  final GlucoseDatabase database;
  final AnalysisSessionStore store;
  final AppSettings settings;
  final String subjectId;
  final AnalysisSubject? subject;

  const RestoreAnalysisSessionUseCase({
    required this.database,
    required this.store,
    this.settings = const AppSettings(),
    this.subjectId = GlucoseSubject.selfId,
    this.subject,
  });

  Future<bool> call() async {
    final insights = await database.latestGeneratedInsights(
      limit: 20,
      subjectId: subjectId,
    );
    final pattern = await database.latestJsonSnapshot(
      GlucoseDatabase.patternSnapshotsTable,
      moduleCode: AnalysisModuleCode.insights.code,
      subjectId: subjectId,
    );
    final daily = await database.latestDailyStats(
      limit: 90,
      subjectId: subjectId,
    );
    final events =
        pattern == null
            ? await database.latestEvents(limit: 200, subjectId: subjectId)
            : await database.eventsBetween(
              pattern.windowStart,
              pattern.windowEnd,
              subjectId: subjectId,
            );
    final windowKey = _windowKey(pattern?.key);
    final periods =
        windowKey == null
            ? const <PeriodGlucoseSummary>[]
            : await database.periodStatsForWindow(
              windowKey,
              subjectId: subjectId,
            );
    final now = DateTime.now();
    final windowStart =
        pattern?.windowStart ?? now.subtract(const Duration(days: 90));
    final windowEnd = pattern?.windowEnd ?? now;
    final readings = await database.range(
      windowStart,
      windowEnd,
      subjectId: subjectId,
    );

    if (insights.isEmpty &&
        pattern == null &&
        daily.isEmpty &&
        periods.isEmpty &&
        events.isEmpty &&
        readings.isEmpty) {
      return false;
    }

    store.update(
      AnalysisRefreshResult(
        snapshot: AnalysisSnapshot(
          generatedAt: pattern?.updatedAt ?? DateTime.now(),
          windowStart: windowStart,
          windowEnd: windowEnd,
          readings: readings,
          dailySummaries: daily,
          periodSummaries: periods,
          events: events,
        ),
        insights: insights,
        subjectId: subjectId,
      ),
      settings: settings,
      subject: subject,
    );
    return true;
  }

  String? _windowKey(String? snapshotKey) {
    if (snapshotKey == null) return null;
    const prefix = 'patterns_';
    if (!snapshotKey.startsWith(prefix)) return null;
    return snapshotKey.substring(prefix.length);
  }
}
