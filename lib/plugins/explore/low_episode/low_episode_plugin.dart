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
import 'pages/low_episode_page.dart';

class LowEpisodePlugin extends SmartFeaturePlugin {
  const LowEpisodePlugin();

  @override
  PluginId get id => const PluginId('explore.low_episode');

  @override
  String get title => 'Low Episode';

  @override
  String get description => 'Low glucose episode detail analysis.';

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
    title: 'Low Episode',
    subtitle: 'Hypoglycemia analysis',
    route: '/explore/low-episode',
    icon: Icons.arrow_downward_rounded,
    accentColor: AppColors.blue,
    order: 310,
  );

  @override
  List<PluginRoute> get routes => [
    PluginRoute(
      path: '/explore/low-episode',
      builder: (_) => const LowEpisodePage(),
    ),
  ];

  @override
  void install(PluginInstallContext context) {
    EpisodeDetailRuntimeInstaller.install(context);
  }
}
