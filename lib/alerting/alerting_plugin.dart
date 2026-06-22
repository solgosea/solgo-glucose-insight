import 'package:flutter/material.dart';

import '../plugin_platform/contracts/plugin_data_requirement.dart';
import '../plugin_platform/contracts/plugin_entry.dart';
import '../plugin_platform/contracts/plugin_id.dart';
import '../plugin_platform/contracts/plugin_placement.dart';
import '../plugin_platform/contracts/plugin_release_stage.dart';
import '../plugin_platform/contracts/plugin_route.dart';
import '../plugin_platform/contracts/smart_feature_plugin.dart';
import '../plugin_platform/composition/plugin_placement_spec.dart';
import '../plugin_platform/install/plugin_install_context.dart';
import '../plugin_platform/rendering/plugin_renderable.dart';
import '../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import '../application/platform_runtime/platform_runtime_capability_snapshot.dart';
import '../plugins/settings/composition/settings_slots.dart';
import 'application/i18n/alerting_entry_localizer.dart';
import 'application/i18n/alerting_l10n_resolver.dart';
import 'alerting_runtime_factory.dart';
import 'data/schema/alerting_schema_contributor.dart';
import 'runtime/alert_runtime_coordinator.dart';
import 'presentation/widgets/alert_settings_entry_card.dart';
import 'presentation/pages/alert_settings_page.dart';
import 'runtime/alerting_plugin_runtime.dart';

class AlertingPlugin extends SmartFeaturePlugin {
  const AlertingPlugin();

  static final _strings = AlertingL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('core.alerting');

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
        PluginPlacement.settingsSection,
      };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.appSettings,
      };

  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: SettingsSlots.section,
          renderKey: 'Alerts',
          title: _strings.alertingTitle,
          order: 25,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  SectionPluginEntry get settingsEntry => SectionPluginEntry(
        pluginId: id.value,
        section: 'Alerts',
        title: _strings.alertingTitle,
        subtitle: _strings.settingsEntrySubtitle,
        order: 25,
      );

  @override
  List<PluginRoute> get routes => const [
        PluginRoute(
          path: '/alerting/settings',
          builder: _buildSettings,
        ),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const AlertingEntryLocalizer());
    context.registerSchema(const AlertingSchemaContributor());
    final runtimeFactory = context.services.get<AlertingRuntimeFactory>();
    context.services.register(
      runtimeFactory.textRendererRegistry(),
      replace: true,
    );
    context.services.register(runtimeFactory.eventFactory(), replace: true);
    final runtimeCoordinator = AlertRuntimeCoordinator(
      platformCapabilities:
          context.services.get<PlatformRuntimeCapabilitySnapshot>(),
    );
    final runtime = AlertingPluginRuntime(
      alertingCenter: runtimeFactory.center(),
      queueConsumer: runtimeFactory.queueConsumer(),
      sourceRegistry: runtimeFactory.sourceRegistry(),
      sourceSink: runtimeFactory.sourceSink(),
      runtimeCoordinator: runtimeCoordinator,
      configureNotificationActions: runtimeFactory.configureNotificationActions,
    );
    context.services.register<AlertRuntimeCoordinator>(runtimeCoordinator);
    context.services.register<AlertingPluginRuntime>(runtime);
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: SettingsSlots.section,
        renderKey: 'alerting.settings.section',
        title: 'Alerts',
        order: 25,
        builder: (_) => const AlertSettingsEntryCard(),
      ),
    );
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }

  static Widget _buildSettings(BuildContext context) {
    return const AlertSettingsPage();
  }
}
