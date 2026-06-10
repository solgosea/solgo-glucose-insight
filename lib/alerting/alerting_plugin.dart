import 'package:flutter/material.dart';

import '../plugin_platform/contracts/plugin_data_requirement.dart';
import '../plugin_platform/contracts/plugin_entry.dart';
import '../plugin_platform/contracts/plugin_id.dart';
import '../plugin_platform/contracts/plugin_placement.dart';
import '../plugin_platform/contracts/plugin_release_stage.dart';
import '../plugin_platform/contracts/plugin_route.dart';
import '../plugin_platform/contracts/smart_feature_plugin.dart';
import '../plugin_platform/install/plugin_install_context.dart';
import '../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'alerting_runtime_factory.dart';
import 'data/schema/alerting_schema_contributor.dart';
import 'presentation/pages/alert_settings_page.dart';
import 'runtime/alerting_plugin_runtime.dart';

class AlertingPlugin extends SmartFeaturePlugin {
  const AlertingPlugin();

  @override
  PluginId get id => const PluginId('core.alerting');

  @override
  String get title => 'Alerting';

  @override
  String get description => 'Configurable alert delivery strategies.';

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
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
    section: 'Alerts',
    title: 'Alert Settings',
    subtitle: 'Sound, vibration, notification strategies',
    order: 25,
  );

  @override
  List<PluginRoute> get routes => const [
    PluginRoute(path: '/alerting/settings', builder: _buildSettings),
  ];

  @override
  void install(PluginInstallContext context) {
    context.registerSchema(const AlertingSchemaContributor());
    final runtimeFactory = context.services.get<AlertingRuntimeFactory>();
    final runtime = AlertingPluginRuntime(
      alertingCenter: runtimeFactory.center(),
      queueConsumer: runtimeFactory.queueConsumer(),
      sourceRegistry: runtimeFactory.sourceRegistry(),
      sourceSink: runtimeFactory.sourceSink(),
    );
    context.services.register<AlertingPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }

  static Widget _buildSettings(BuildContext context) {
    return const AlertSettingsPage();
  }
}
