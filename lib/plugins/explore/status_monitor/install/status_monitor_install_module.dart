import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';

import '../data/schema/status_monitor_schema_contributor.dart';
import 'status_monitor_composition_registrar.dart';
import 'status_monitor_runtime_registrar.dart';
import 'status_monitor_service_registrar.dart';

class StatusMonitorInstallModule {
  final StatusMonitorServiceRegistrar serviceRegistrar;
  final StatusMonitorCompositionRegistrar compositionRegistrar;
  final StatusMonitorRuntimeRegistrar runtimeRegistrar;

  const StatusMonitorInstallModule({
    this.serviceRegistrar = const StatusMonitorServiceRegistrar(),
    this.compositionRegistrar = const StatusMonitorCompositionRegistrar(),
    this.runtimeRegistrar = const StatusMonitorRuntimeRegistrar(),
  });

  void install(PluginInstallContext context, PluginId pluginId) {
    context.registerSchema(const StatusMonitorSchemaContributor());
    final bundle = serviceRegistrar.install(context);
    compositionRegistrar.register(context, pluginId);
    runtimeRegistrar.register(context, bundle);
  }
}
