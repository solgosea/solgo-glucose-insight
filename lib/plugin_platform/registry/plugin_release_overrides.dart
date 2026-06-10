import '../contracts/plugin_release_stage.dart';
import '../contracts/plugin_id.dart';

class PluginReleaseOverrides {
  final Map<String, PluginReleaseStage> _stages;

  const PluginReleaseOverrides({
    Map<String, PluginReleaseStage> stages = const {},
  }) : _stages = stages;

  PluginReleaseStage stageFor(PluginId id, PluginReleaseStage fallback) {
    return _stages[id.value] ?? fallback;
  }
}
