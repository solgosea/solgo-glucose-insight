import 'plugin_id.dart';
import 'plugin_runtime_status.dart';

class PluginRuntimeState {
  final PluginId pluginId;
  final PluginRuntimeStatus status;
  final String? reason;

  const PluginRuntimeState({
    required this.pluginId,
    required this.status,
    this.reason,
  });

  bool get visible => status != PluginRuntimeStatus.hidden;

  bool get enabled => status == PluginRuntimeStatus.available;

  bool get actionable => visible && enabled;
}
