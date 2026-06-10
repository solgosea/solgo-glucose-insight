import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';

class ExploreRuntimeRefreshPolicy {
  const ExploreRuntimeRefreshPolicy();

  bool shouldRefresh(PluginRuntimeEventType eventType) {
    return switch (eventType) {
      PluginRuntimeEventType.appStarted ||
      PluginRuntimeEventType.appResumed ||
      PluginRuntimeEventType.activeSubjectChanged ||
      PluginRuntimeEventType.subjectDataChanged ||
      PluginRuntimeEventType.settingsChanged ||
      PluginRuntimeEventType.datasourceChanged => true,
      PluginRuntimeEventType.appPaused ||
      PluginRuntimeEventType.custom => false,
    };
  }
}
