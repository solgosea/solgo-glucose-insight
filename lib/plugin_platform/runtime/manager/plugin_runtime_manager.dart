import '../../contracts/plugin_id.dart';
import '../contracts/plugin_runtime.dart';
import '../contracts/plugin_runtime_context.dart';
import '../events/plugin_runtime_event.dart';
import '../events/plugin_runtime_event_bus.dart';
import '../events/plugin_runtime_event_type.dart';
import '../state/plugin_runtime_store.dart';
import 'plugin_runtime_registry.dart';
import 'plugin_runtime_start_policy.dart';

class PluginRuntimeManager {
  final PluginRuntimeRegistry registry;
  final PluginRuntimeStore store;
  final PluginRuntimeEventBus eventBus;
  final PluginRuntimeContext context;

  final Set<PluginId> _running = {};
  final Set<PluginId> _starting = {};

  PluginRuntimeManager._({
    required this.registry,
    required this.store,
    required this.eventBus,
    required this.context,
  });

  factory PluginRuntimeManager.create({DateTime Function()? now}) {
    final store = PluginRuntimeStore(now: now);
    final eventBus = PluginRuntimeEventBus();
    return PluginRuntimeManager._(
      registry: PluginRuntimeRegistry(),
      store: store,
      eventBus: eventBus,
      context: PluginRuntimeContext(eventBus: eventBus, store: store, now: now),
    );
  }

  void register(
    PluginRuntime runtime, {
    PluginRuntimeStartPolicy startPolicy = PluginRuntimeStartPolicy.onEnter,
  }) {
    registry.register(runtime, startPolicy: startPolicy);
    store.register(runtime.pluginId, capability: runtime.capability);
  }

  Future<void> startAppRuntimes() async {
    eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.appStarted,
        occurredAt: context.now(),
      ),
    );
    for (final handle in registry.handles) {
      if (handle.startPolicy == PluginRuntimeStartPolicy.appStart) {
        await start(handle.runtime.pluginId);
      }
    }
  }

  Future<void> start(PluginId pluginId) async {
    final runtime = registry.handleFor(pluginId)?.runtime;
    if (runtime == null || _running.contains(pluginId)) return;
    if (_starting.contains(pluginId)) return;
    _starting.add(pluginId);
    context.markStarting(pluginId);
    try {
      await runtime.start(context);
      _running.add(pluginId);
      context.markRunning(pluginId);
    } catch (error) {
      context.markFailed(pluginId, error);
      rethrow;
    } finally {
      _starting.remove(pluginId);
    }
  }

  Future<void> resume(PluginId pluginId) async {
    final runtime = registry.handleFor(pluginId)?.runtime;
    if (runtime == null) return;
    if (!_running.contains(pluginId)) {
      await start(pluginId);
      return;
    }
    await runtime.resume(context);
    context.markRunning(pluginId);
  }

  Future<void> pause(PluginId pluginId) async {
    final runtime = registry.handleFor(pluginId)?.runtime;
    if (runtime == null || !_running.contains(pluginId)) return;
    await runtime.pause(context);
    context.markPaused(pluginId);
  }

  Future<void> stop(PluginId pluginId) async {
    final runtime = registry.handleFor(pluginId)?.runtime;
    if (runtime == null) return;
    await runtime.stop(context);
    _running.remove(pluginId);
    context.markStopped(pluginId);
  }

  Future<void> dispose() async {
    for (final pluginId in _running.toList(growable: false)) {
      await stop(pluginId);
    }
    await eventBus.dispose();
  }
}
