import '../../alerting/alerting_runtime_factory.dart';
import '../../application/data_source_runtime/data_source_runtime_coordinator.dart';
import '../../application/subject/active_subject_service.dart';
import '../../data/local/glucose_database.dart';
import '../../domain/entities/app_settings.dart';
import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'runtime/data_source_plugin_runtime.dart';
import 'alert_source/local_glucose_alert_source.dart';

class DataSourcePlugin extends SmartFeaturePlugin {
  const DataSourcePlugin();

  @override
  PluginId get id => const PluginId('profile.data_source');

  @override
  String get title => 'Data Source';

  @override
  String get description => 'xDrip Local and Nightscout source connection.';

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
  SectionPluginEntry get profileEntry => const SectionPluginEntry(
    section: 'Data Source',
    title: 'Data Source',
    subtitle: 'xDrip Local and Nightscout API',
    order: 20,
  );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    final alertingRuntimeFactory =
        context.services.get<AlertingRuntimeFactory>();
    final source = LocalGlucoseAlertSource(
      database: context.services.get<GlucoseDatabase>(),
      settingsProvider: context.services.get<AppSettings Function()>(),
      subjectIdProvider:
          () => context.services.get<ActiveSubjectService>().current.id,
      ruleProvider: alertingRuntimeFactory.ruleProvider(),
    );
    alertingRuntimeFactory.sourceRegistry().register(source);
    context.services.register<LocalGlucoseAlertSource>(source);
    context.registerRuntime(
      DataSourcePluginRuntime(
        coordinator: context.services.get<DataSourceRuntimeCoordinator>(),
        settingsProvider: context.services.get<AppSettings Function()>(),
        alertSource: source,
      ),
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }
}
