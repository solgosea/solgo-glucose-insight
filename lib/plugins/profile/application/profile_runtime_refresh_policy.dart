import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';

class ProfileRuntimeRefreshPolicy {
  const ProfileRuntimeRefreshPolicy();

  bool shouldRefresh(PluginRuntimeEventType eventType) {
    return switch (eventType) {
      PluginRuntimeEventType.subjectDataChanged ||
      PluginRuntimeEventType.activeSubjectChanged ||
      PluginRuntimeEventType.settingsChanged ||
      PluginRuntimeEventType.datasourceChanged => true,
      PluginRuntimeEventType.appStarted ||
      PluginRuntimeEventType.appResumed ||
      PluginRuntimeEventType.appPaused ||
      PluginRuntimeEventType.custom => false,
    };
  }
}
