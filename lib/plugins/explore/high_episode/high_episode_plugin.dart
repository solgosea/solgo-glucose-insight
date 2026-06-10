import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../../plugin_platform/install/plugin_install_context.dart';
import '../episode_detail/install/episode_detail_runtime_installer.dart';
import 'pages/high_episode_page.dart';

class HighEpisodePlugin extends SmartFeaturePlugin {
  const HighEpisodePlugin();

  @override
  PluginId get id => const PluginId('explore.high_episode');

  @override
  String get title => 'High Episode';

  @override
  String get description => 'High glucose episode detail analysis.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.exploreCard};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.glucoseEvents,
    PluginDataRequirement.appSettings,
  };

  @override
  ExplorePluginEntry get exploreEntry => const ExplorePluginEntry(
    section: 'EPISODES',
    title: 'High Episode',
    subtitle: 'Hyperglycemia analysis',
    route: '/explore/high-episode',
    icon: Icons.arrow_upward_rounded,
    accentColor: AppColors.rose,
    order: 300,
  );

  @override
  List<PluginRoute> get routes => [
    PluginRoute(
      path: '/explore/high-episode',
      builder: (_) => const HighEpisodePage(),
    ),
  ];

  @override
  void install(PluginInstallContext context) {
    EpisodeDetailRuntimeInstaller.install(context);
  }
}
