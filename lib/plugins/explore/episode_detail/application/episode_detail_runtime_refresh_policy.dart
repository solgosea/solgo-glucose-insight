import '../../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';

class EpisodeDetailRuntimeRefreshPolicy {
  const EpisodeDetailRuntimeRefreshPolicy();

  bool shouldRefresh(PluginRuntimeEventType eventType) {
    return switch (eventType) {
      PluginRuntimeEventType.subjectDataChanged ||
      PluginRuntimeEventType.activeSubjectChanged ||
      PluginRuntimeEventType.settingsChanged => true,
      PluginRuntimeEventType.appStarted ||
      PluginRuntimeEventType.appResumed ||
      PluginRuntimeEventType.appPaused ||
      PluginRuntimeEventType.datasourceChanged ||
      PluginRuntimeEventType.custom => false,
    };
  }

  bool shouldMarkStale(PluginRuntimeEventType eventType) {
    return switch (eventType) {
      PluginRuntimeEventType.datasourceChanged => true,
      PluginRuntimeEventType.appStarted ||
      PluginRuntimeEventType.appResumed ||
      PluginRuntimeEventType.appPaused ||
      PluginRuntimeEventType.settingsChanged ||
      PluginRuntimeEventType.activeSubjectChanged ||
      PluginRuntimeEventType.subjectDataChanged ||
      PluginRuntimeEventType.custom => false,
    };
  }
}
