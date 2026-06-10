import '../../application/analysis/analysis_session_store.dart';
import '../../application/analysis/analysis_session_capability_service.dart';
import '../contracts/plugin_capability.dart';

class PluginCapabilityContextFactory {
  final AnalysisSessionStore analysisStore;

  const PluginCapabilityContextFactory({required this.analysisStore});

  factory PluginCapabilityContextFactory.current() =>
      PluginCapabilityContextFactory(
        analysisStore: AnalysisSessionStore.instance,
      );

  PluginCapabilityContext create() {
    final summary =
        AnalysisSessionCapabilityService(store: analysisStore).summarize();
    return PluginCapabilityContext(
      activeSubject: summary.activeSubject,
      hasGlucoseData: summary.hasGlucoseData,
      hasConfiguredSource: summary.hasConfiguredSource,
      readingsCount: summary.readingsCount,
      eventsCount: summary.eventsCount,
      dailySummaryCount: summary.dailySummaryCount,
      periodSummaryCount: summary.periodSummaryCount,
      generatedAt: summary.generatedAt,
    );
  }
}
