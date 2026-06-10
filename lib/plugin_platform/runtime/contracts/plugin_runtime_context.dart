import '../../contracts/plugin_id.dart';
import '../events/plugin_runtime_event_bus.dart';
import '../state/plugin_runtime_store.dart';

class PluginRuntimeContext {
  final PluginRuntimeEventBus eventBus;
  final PluginRuntimeStore store;
  final DateTime Function() now;

  const PluginRuntimeContext({
    required this.eventBus,
    required this.store,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  void markStarting(PluginId pluginId) => store.markStarting(pluginId);

  void markRunning(PluginId pluginId) => store.markRunning(pluginId);

  void markPaused(PluginId pluginId) => store.markPaused(pluginId);

  void markStopped(PluginId pluginId) => store.markStopped(pluginId);

  void markFailed(PluginId pluginId, Object error) {
    store.markFailed(pluginId, error.toString());
  }
}
