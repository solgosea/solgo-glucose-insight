import '../../../domain/analysis/analysis_context.dart';
import '../../../domain/analysis/analysis_module_code.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../engine/detection/episode_detector.dart';
import 'analysis_module.dart';

class EventAnalysisModule implements AnalysisModule<List<GlucoseEvent>> {
  const EventAnalysisModule();

  @override
  AnalysisModuleCode get code => AnalysisModuleCode.highEpisode;

  @override
  Future<List<GlucoseEvent>> run(AnalysisContext context) async =>
      EpisodeDetector.detect(
        context.readings,
        low: context.settings.lowThreshold,
        high: context.settings.highThreshold,
      );
}
