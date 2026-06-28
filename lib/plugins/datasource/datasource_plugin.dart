import 'package:smart_xdrip/alerting/alerting_runtime_factory.dart';
import 'package:smart_xdrip/application/data_source_runtime/data_source_runtime_coordinator.dart';
import 'package:smart_xdrip/application/i18n/app_locale_controller.dart';
import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_renderable.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'package:smart_xdrip/plugins/profile/composition/profile_slots.dart';

import 'alert_source/local_glucose_alert_source.dart';
import 'application/datasource_capability_adapter.dart';
import 'presentation/profile_section/datasource_profile_section.dart';
import 'runtime/datasource_plugin_runtime.dart';
import 'application/i18n/datasource_l10n_resolver.dart';
import 'application/i18n/datasource_entry_localizer.dart';

class DatasourcePlugin extends SmartFeaturePlugin {
  const DatasourcePlugin();

  static final _strings = DatasourceL10nResolver.fallback;

  @override
  PluginId get id => DatasourcePluginRuntime.id;

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.profileSection};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.sourceConnection,
        PluginDataRequirement.appSettings,
      };

  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: ProfileSlots.section,
          renderKey: 'Data Source',
          title: _strings.pluginTitle,
          order: 20,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const DatasourceEntryLocalizer());
    final alertingRuntimeFactory =
        context.services.get<AlertingRuntimeFactory>();
    final coordinator = context.services.get<DataSourceRuntimeCoordinator>();
    final settingsProvider = context.services.get<AppSettings Function()>();
    final source = LocalGlucoseAlertSource(
      database: context.services.get<GlucoseDatabase>(),
      settingsProvider: settingsProvider,
      subjectIdProvider: () =>
          context.services.get<ActiveSubjectService>().current.id,
      ruleProvider: alertingRuntimeFactory.ruleProvider(),
      eventFactory: alertingRuntimeFactory.eventFactory(),
      localeProvider: () => context.services.get<AppLocaleController>().locale,
    );
    alertingRuntimeFactory.sourceRegistry().register(source);
    context.services.register<LocalGlucoseAlertSource>(source);
    context.services.register(
      DatasourceCapabilityAdapter(
        coordinator: coordinator,
        settingsProvider: settingsProvider,
      ),
    );
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: ProfileSlots.section,
        renderKey: 'datasource.profile.section',
        title: _strings.pluginTitle,
        order: 20,
        builder: (renderContext) => DatasourceProfileSection(
          renderContext: renderContext,
        ),
      ),
    );
    context.registerRuntime(
      DatasourcePluginRuntime(
        coordinator: coordinator,
        settingsProvider: settingsProvider,
        alertSource: source,
      ),
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }
}
