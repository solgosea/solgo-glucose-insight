import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';

import 'status_monitor_service_bundle.dart';

class StatusMonitorRuntimeRegistrar {
  const StatusMonitorRuntimeRegistrar();

  void register(
      PluginInstallContext context, StatusMonitorServiceBundle bundle) {
    context.registerRuntime(
      bundle.runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
