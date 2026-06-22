import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/composition/plugin_placement_spec.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/rendering/plugin_renderable.dart';
import 'composition/profile_slots.dart';
import 'target_range/profile_section/target_range_profile_section.dart';
import 'application/i18n/profile_l10n_resolver.dart';

class TargetRangePlugin extends SmartFeaturePlugin {
  const TargetRangePlugin();

  static final _strings = ProfileL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('profile.target_range');

  @override
  String get title => _strings.targetRangeTitle;

  @override
  String get description => _strings.targetRangeDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.profileSection};

  @override
  Set<PluginDataRequirement> get dataRequirements =>
      const {PluginDataRequirement.appSettings};

  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: ProfileSlots.section,
          renderKey: 'Target Range',
          title: _strings.targetRangeTitle,
          order: 30,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: ProfileSlots.section,
        renderKey: 'target_range.profile.section',
        title: _strings.targetRangeTitle,
        order: 30,
        builder: (renderContext) => TargetRangeProfileSection(
          renderContext: renderContext,
        ),
      ),
    );
  }
}
