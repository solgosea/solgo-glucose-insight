import '../../data/local/glucose_database.dart';
import '../../domain/analysis/analysis_module_code.dart';
import '../../domain/analysis/analysis_snapshot.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/insight/narrative_insight.dart';
import '../../domain/subject/glucose_subject.dart';
import 'default_insight_templates.dart';
import 'insight_fact_builder.dart';
import 'insight_render_pipeline.dart';

class InsightGenerationService {
  final GlucoseDatabase database;
  final InsightFactBuilder factBuilder;
  final InsightRenderPipeline renderPipeline;

  const InsightGenerationService({
    required this.database,
    this.factBuilder = const InsightFactBuilder(),
    this.renderPipeline = const InsightRenderPipeline(),
  });

  Future<void> seedTemplates() async {
    await database.upsertInsightTemplates(DefaultInsightTemplates.all);
  }

  Future<List<NarrativeInsight>> generate(
    AnalysisSnapshot snapshot, {
    required AppSettings settings,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final facts = factBuilder.build(snapshot, settings);
    final templates = await database.templatesForModule(
      AnalysisModuleCode.insights,
    );
    final insights = renderPipeline.renderAll(
      factBundles: facts,
      templates: templates,
      generatedAt: DateTime.now(),
    );

    await database.upsertGeneratedInsights(insights, subjectId: subjectId);
    return insights;
  }
}
