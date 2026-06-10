import '../../plugin_platform/contracts/plugin_release_stage.dart';
import 'plugin_release_profile.dart';

class PluginReleaseMatrix {
  final PluginReleaseProfile profile;
  final Set<String> enabledBundles;
  final Map<String, PluginReleaseStage> pluginOverrides;

  const PluginReleaseMatrix({
    required this.profile,
    required this.enabledBundles,
    this.pluginOverrides = const {},
  });
}
