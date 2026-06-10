import '../../domain/subject/analysis_subject.dart';
import '../../domain/subject/analysis_subject_origin.dart';
import '../../application/subject/active_subject_defaults.dart';
import 'plugin_release_stage.dart';

class PluginCapabilityContext {
  final AnalysisSubject activeSubject;
  final bool hasGlucoseData;
  final bool hasConfiguredSource;
  final int readingsCount;
  final int eventsCount;
  final int dailySummaryCount;
  final int periodSummaryCount;
  final DateTime? generatedAt;

  const PluginCapabilityContext({
    this.activeSubject = ActiveSubjectDefaults.self,
    this.hasGlucoseData = true,
    this.hasConfiguredSource = true,
    this.readingsCount = 0,
    this.eventsCount = 0,
    this.dailySummaryCount = 0,
    this.periodSummaryCount = 0,
    this.generatedAt,
  });

  AnalysisSubjectOrigin get subjectOrigin => activeSubject.origin;

  bool get hasGlucoseEvents => eventsCount > 0;

  bool get hasDailySummaries => dailySummaryCount > 0;

  bool get hasPeriodSummaries => periodSummaryCount > 0;
}

class PluginCapability {
  final bool visible;
  final bool enabled;
  final String? reason;

  const PluginCapability({
    required this.visible,
    required this.enabled,
    this.reason,
  });

  factory PluginCapability.fromReleaseStage(
    PluginReleaseStage stage, {
    String? reason,
  }) {
    return PluginCapability(
      visible: stage.isVisible,
      enabled: stage.isEnabled,
      reason: stage.isEnabled ? reason : reason ?? _reasonFor(stage),
    );
  }

  static String? _reasonFor(PluginReleaseStage stage) {
    return switch (stage) {
      PluginReleaseStage.hidden => 'Hidden',
      PluginReleaseStage.comingSoon => 'Coming soon',
      PluginReleaseStage.deprecated => 'Deprecated',
      PluginReleaseStage.beta || PluginReleaseStage.stable => null,
    };
  }
}
