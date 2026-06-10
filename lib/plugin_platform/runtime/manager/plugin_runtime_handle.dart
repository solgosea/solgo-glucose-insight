import '../contracts/plugin_runtime.dart';
import 'plugin_runtime_start_policy.dart';

class PluginRuntimeHandle {
  final PluginRuntime runtime;
  final PluginRuntimeStartPolicy startPolicy;

  const PluginRuntimeHandle({required this.runtime, required this.startPolicy});
}
