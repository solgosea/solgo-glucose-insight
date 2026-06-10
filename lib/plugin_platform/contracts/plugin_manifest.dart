import 'plugin_data_requirement.dart';
import 'plugin_id.dart';
import 'plugin_placement.dart';
import 'plugin_release_stage.dart';

class PluginManifest {
  final PluginId id;
  final String title;
  final String description;
  final PluginReleaseStage releaseStage;
  final Set<PluginPlacement> placements;
  final Set<PluginDataRequirement> dataRequirements;

  const PluginManifest({
    required this.id,
    required this.title,
    required this.description,
    required this.releaseStage,
    required this.placements,
    required this.dataRequirements,
  });
}
