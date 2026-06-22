import '../../plugin_platform/composition/plugin_placement_spec.dart';
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
import 'widgets/home_insight_banner.dart';
import 'widgets/home_render_scope.dart';
import 'application/i18n/home_l10n_resolver.dart';

class HomeInsightWidgetPlugin extends SmartFeaturePlugin {
  const HomeInsightWidgetPlugin();

  static final _strings = HomeL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('home.insight');

  @override
  String get title => _strings.homeInsightTitle;

  @override
  String get description => _strings.homeInsightDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.homeWidget};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.glucoseReadings,
        PluginDataRequirement.dailySummaries,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: HomeSlots.widget,
          renderKey: 'home.insight',
          title: _strings.homeInsightTitle,
          order: 60,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => HomeWidgetPluginEntry(
        widgetKey: 'home.insight',
        title: _strings.homeInsightTitle,
        description: _strings.homeInsightSubtitle,
        order: 60,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: HomeSlots.widget,
        renderKey: 'home.insight',
        title: _strings.homeInsightTitle,
        order: 60,
        builder: (renderContext) {
          final scope = HomeRenderScope.of(renderContext.buildContext);
          return HomeInsightBanner(
            text: scope.viewModel.insightText,
            onTap: scope.onInsightTap,
          );
        },
      ),
    );
  }
}
