import '../../plugin_platform/composition/plugin_placement_spec.dart';
import 'package:flutter/widgets.dart';

import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/rendering/plugin_renderable.dart';
import 'composition/home_slots.dart';
import 'widgets/home_render_scope.dart';
import 'widgets/home_stats_row.dart';
import 'application/i18n/home_l10n_resolver.dart';

class HomeStatsWidgetPlugin extends SmartFeaturePlugin {
  const HomeStatsWidgetPlugin();

  static final _strings = HomeL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('home.stats');

  @override
  String get title => _strings.homeStatsTitle;

  @override
  String get description => _strings.homeStatsDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.homeWidget};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.glucoseReadings,
        PluginDataRequirement.appSettings,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: HomeSlots.widget,
          renderKey: 'home.stats',
          title: _strings.homeStatsTitle,
          order: 40,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => HomeWidgetPluginEntry(
        widgetKey: 'home.stats',
        title: _strings.homeStatsTitle,
        description: _strings.homeStatsSubtitle,
        order: 40,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: HomeSlots.widget,
        renderKey: 'home.stats',
        title: _strings.homeStatsTitle,
        order: 40,
        builder: (renderContext) {
          final scope = HomeRenderScope.of(renderContext.buildContext);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeStatsRow(stats: scope.viewModel.stats),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
