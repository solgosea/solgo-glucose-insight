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
import '../episode_detail/reports/presentation/low/low_episode_report_preview_page.dart';
import 'pages/low_episode_page.dart';
import 'application/i18n/low_episode_entry_localizer.dart';
import 'application/i18n/low_episode_l10n_resolver.dart';

class LowEpisodePlugin extends SmartFeaturePlugin {
  const LowEpisodePlugin();

  static final _strings = LowEpisodeL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('explore.low_episode');

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
          renderKey: '/explore/low-episode',
          title: _strings.pluginTitle,
          order: 310,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  ExplorePluginEntry get exploreEntry => ExplorePluginEntry(
        section: 'EPISODES',
        title: _strings.pluginTitle,
        subtitle: _strings.pluginTitle,
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
        PluginRoute.state(
          path: '/explore/low-episode/report-preview',
          builder: (_, state) => LowEpisodeReportPreviewPage(uri: state.uri),
        ),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const LowEpisodeEntryLocalizer());
    EpisodeDetailRuntimeInstaller.install(context);
  }
}
