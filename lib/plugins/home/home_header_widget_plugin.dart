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
import 'widgets/home_header.dart';
import 'widgets/home_render_scope.dart';
import 'application/i18n/home_l10n_resolver.dart';

class HomeHeaderWidgetPlugin extends SmartFeaturePlugin {
  const HomeHeaderWidgetPlugin();

  static final _strings = HomeL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('home.header');

  @override
  String get title => _strings.homeHeaderTitle;

  @override
  String get description => _strings.homeHeaderDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.homeWidget};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.syncStatus,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: HomeSlots.widget,
          renderKey: 'home.header',
          title: _strings.homeHeaderTitle,
          order: 10,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => HomeWidgetPluginEntry(
        widgetKey: 'home.header',
        title: _strings.homeHeaderTitle,
        description: _strings.homeHeaderSubtitle,
        order: 10,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: HomeSlots.widget,
        renderKey: 'home.header',
        title: _strings.homeHeaderTitle,
        order: 10,
        builder: (renderContext) {
          final scope = HomeRenderScope.of(renderContext.buildContext);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeader(
                viewModel: scope.viewModel,
                onSwitchBackToSelf: scope.onSwitchBackToSelf,
                onUnitChanged: scope.onUnitChanged,
              ),
              const SizedBox(height: 4),
            ],
          );
        },
      ),
    );
  }
}
