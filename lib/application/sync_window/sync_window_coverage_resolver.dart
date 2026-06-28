import '../../data/local/glucose_database.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import '../../domain/sync_window/sync_window_coverage.dart';

class SyncWindowCoverageResolver {
  final GlucoseDatabase database;

  const SyncWindowCoverageResolver({
    required this.database,
  });

  Future<SyncWindowCoverage> resolve(GlucoseSyncTarget target) async {
    final sourceKey = target.source.type.name;
    final state = await database.getSourceState(
      sourceKey,
      subjectId: target.subjectId,
    );
    final actualEarliest =
        (await database.earliest(subjectId: target.subjectId))?.timestamp;
    final actualLatest =
        (await database.latest(subjectId: target.subjectId))?.timestamp;
    final earliest = _actualCoverageStart(
      recorded: state?.coveredFrom,
      actual: actualEarliest,
    );
    final latest = _actualCoverageEnd(
      recorded: state?.coveredTo,
      actual: actualLatest,
    );
    return SyncWindowCoverage(
      subjectId: target.subjectId,
      sourceKey: sourceKey,
      coveredFrom: earliest,
      coveredTo: latest,
      syncWindowDays: state?.syncWindowDays,
    );
  }

  DateTime? _actualCoverageStart({
    required DateTime? recorded,
    required DateTime? actual,
  }) {
    if (actual == null) return null;
    if (recorded == null) return actual;
    return actual.isAfter(recorded) ? actual : recorded;
  }

  DateTime? _actualCoverageEnd({
    required DateTime? recorded,
    required DateTime? actual,
  }) {
    if (actual == null) return null;
    if (recorded == null) return actual;
    return actual.isBefore(recorded) ? actual : recorded;
  }
}
