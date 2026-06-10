import 'dart:async';

import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/settings_runtime_refresh_policy.dart';
import '../application/settings_snapshot_preheater.dart';
import 'settings_runtime_cache.dart';

class SettingsPluginRuntime implements PluginRuntime {
  static const id = PluginId('core.settings');

  final SettingsRuntimeCache cache;
  final SettingsSnapshotPreheater preheater;
  final SettingsRuntimeRefreshPolicy refreshPolicy;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _preheating = false;

  SettingsPluginRuntime({
    required this.cache,
    required this.preheater,
    this.refreshPolicy = const SettingsRuntimeRefreshPolicy(),
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    _subscription ??= context.eventBus.events.listen((event) {
      if (refreshPolicy.shouldRefresh(event.type)) {
        cache.markStale(event.type.name);
      }
    });
    await _preheatIfNeeded(context, reason: 'start');
  }

  @override
  Future<void> resume(PluginRuntimeContext context) {
    return _preheatIfNeeded(context, reason: 'resume');
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {}

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<SettingsRuntimeSnapshot> preheat() async {
    final snapshot = await preheater.preheat();
    cache.put(snapshot);
    return snapshot;
  }

  Future<void> _preheatIfNeeded(
    PluginRuntimeContext context, {
    required String reason,
  }) async {
    if (_preheating) return;
    if (!cache.stale && cache.latestSnapshot != null) return;
    _preheating = true;
    try {
      final snapshot = await preheat();
      context.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.custom,
          targetPluginId: pluginId,
          occurredAt: context.now(),
          payload: {
            'name': 'settings.preheated',
            'reason': reason,
            'updatedAt': snapshot.updatedAt.toIso8601String(),
          },
        ),
      );
    } catch (error) {
      cache.markStale('preheatFailed');
      context.markFailed(pluginId, error);
    } finally {
      _preheating = false;
    }
  }
}
