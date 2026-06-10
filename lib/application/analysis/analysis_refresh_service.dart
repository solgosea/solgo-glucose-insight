import '../../domain/analysis/analysis_window.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/subject/glucose_subject.dart';
import '../insight/insight_generation_service.dart';
import 'analysis_engine.dart';
import 'analysis_refresh_result.dart';

class AnalysisRefreshService {
  final AnalysisEngine analysisEngine;
  final InsightGenerationService insightService;

  const AnalysisRefreshService({
    required this.analysisEngine,
    required this.insightService,
  });

  Future<AnalysisRefreshResult> refresh({
    required AppSettings settings,
    AnalysisWindow? window,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    await insightService.seedTemplates();
    final snapshot = await analysisEngine.runWindow(
      settings: settings,
      window: window,
      subjectId: subjectId,
    );
    final insights = await insightService.generate(
      snapshot,
      settings: settings,
      subjectId: subjectId,
    );
    return AnalysisRefreshResult(
      snapshot: snapshot,
      insights: insights,
      subjectId: subjectId,
    );
  }
}
