import '../composition/explore_slots.dart';
import '../../../plugin_platform/composition/plugin_placement_spec.dart';
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
import '../episode_detail/reports/presentation/high/high_episode_report_preview_page.dart';
import 'pages/high_episode_page.dart';
import 'application/i18n/high_episode_entry_localizer.dart';
import 'application/i18n/high_episode_l10n_resolver.dart';

class HighEpisodePlugin extends SmartFeaturePlugin {
  const HighEpisodePlugin();

  static final _strings = HighEpisodeL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('explore.high_episode');

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.exploreCard};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.glucoseReadings,
        PluginDataRequirement.episodeEvents,
        PluginDataRequirement.appSettings,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: ExploreSlots.card,
          renderKey: '/explore/high-episode',
          title: _strings.pluginTitle,
          order: 300,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  ExplorePluginEntry get exploreEntry => ExplorePluginEntry(
        section: 'EPISODES',
        title: _strings.pluginTitle,
        subtitle: _strings.pluginTitle,
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
        PluginRoute.state(
          path: '/explore/high-episode/report-preview',
          builder: (_, state) => HighEpisodeReportPreviewPage(uri: state.uri),
        ),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const HighEpisodeEntryLocalizer());
    EpisodeDetailRuntimeInstaller.install(context);
  }
}
