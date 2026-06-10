import '../../domain/analysis/analysis_snapshot.dart';
import '../../domain/insight/narrative_insight.dart';
import '../../domain/subject/glucose_subject.dart';

class AnalysisRefreshResult {
  final AnalysisSnapshot snapshot;
  final List<NarrativeInsight> insights;
  final String subjectId;

  const AnalysisRefreshResult({
    required this.snapshot,
    required this.insights,
    this.subjectId = GlucoseSubject.selfId,
  });
}
