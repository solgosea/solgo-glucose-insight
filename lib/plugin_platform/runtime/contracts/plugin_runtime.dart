import '../../contracts/plugin_id.dart';
import 'plugin_runtime_capability.dart';
import 'plugin_runtime_context.dart';

abstract interface class PluginRuntime {
  PluginId get pluginId;

  PluginRuntimeCapability get capability;

  Future<void> start(PluginRuntimeContext context);

  Future<void> resume(PluginRuntimeContext context);

  Future<void> pause(PluginRuntimeContext context);

  Future<void> stop(PluginRuntimeContext context);
}
