import '../../domain/entities/app_settings.dart';
import '../../domain/subject/analysis_subject_origin.dart';
import 'analysis_session_snapshot_summary.dart';
import 'analysis_session_store.dart';

class AnalysisSessionCapabilityService {
  final AnalysisSessionStore store;

  const AnalysisSessionCapabilityService({required this.store});

  AnalysisSessionSnapshotSummary summarize() {
    final snapshot = store.snapshot;
    final subject = store.activeSubject;
    return AnalysisSessionSnapshotSummary(
      activeSubject: subject,
      readingsCount: snapshot?.readings.length ?? 0,
      eventsCount: snapshot?.events.length ?? 0,
      dailySummaryCount: snapshot?.dailySummaries.length ?? 0,
      periodSummaryCount: snapshot?.periodSummaries.length ?? 0,
      generatedAt: snapshot?.generatedAt,
      hasConfiguredSource: _hasConfiguredSource(
        settings: store.settings,
        subjectOrigin: subject.origin,
        hasSnapshot: snapshot != null,
      ),
    );
  }

  bool _hasConfiguredSource({
    required AppSettings settings,
    required AnalysisSubjectOrigin subjectOrigin,
    required bool hasSnapshot,
  }) {
    if (subjectOrigin != AnalysisSubjectOrigin.self) {
      return hasSnapshot;
    }
    return (settings.xdripBaseUrl?.trim().isNotEmpty ?? false) ||
        (settings.nightscoutBaseUrl?.trim().isNotEmpty ?? false);
  }
}
