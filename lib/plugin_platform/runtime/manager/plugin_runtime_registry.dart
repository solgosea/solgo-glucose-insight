import '../../contracts/plugin_id.dart';
import '../contracts/plugin_runtime.dart';
import 'plugin_runtime_handle.dart';
import 'plugin_runtime_start_policy.dart';

class PluginRuntimeRegistry {
  final Map<PluginId, PluginRuntimeHandle> _handles = {};

  List<PluginRuntimeHandle> get handles => List.unmodifiable(_handles.values);

  PluginRuntimeHandle? handleFor(PluginId pluginId) => _handles[pluginId];

  void register(
    PluginRuntime runtime, {
    PluginRuntimeStartPolicy startPolicy = PluginRuntimeStartPolicy.onEnter,
  }) {
    _handles[runtime.pluginId] = PluginRuntimeHandle(
      runtime: runtime,
      startPolicy: startPolicy,
    );
  }
}
