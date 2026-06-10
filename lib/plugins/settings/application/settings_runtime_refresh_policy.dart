import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';

class SettingsRuntimeRefreshPolicy {
  const SettingsRuntimeRefreshPolicy();

  bool shouldRefresh(PluginRuntimeEventType eventType) {
    return switch (eventType) {
      PluginRuntimeEventType.settingsChanged ||
      PluginRuntimeEventType.subjectDataChanged ||
      PluginRuntimeEventType.datasourceChanged => true,
      PluginRuntimeEventType.appStarted ||
      PluginRuntimeEventType.appResumed ||
      PluginRuntimeEventType.appPaused ||
      PluginRuntimeEventType.activeSubjectChanged ||
      PluginRuntimeEventType.custom => false,
    };
  }
}
