import 'dart:async';

import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/insights_runtime_refresh_policy.dart';
import '../application/insights_snapshot_preheater.dart';
import 'insights_runtime_cache.dart';

class InsightsPluginRuntime implements PluginRuntime {
  static const id = PluginId('analysis.insights');

  final InsightsRuntimeCache cache;
  final InsightsSnapshotPreheater preheater;
  final InsightsRuntimeRefreshPolicy refreshPolicy;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _preheating = false;

  InsightsPluginRuntime({
    required this.cache,
    required this.preheater,
    this.refreshPolicy = const InsightsRuntimeRefreshPolicy(),
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
        unawaited(_preheatIfNeeded(context, reason: event.type.name));
        return;
      }
      if (refreshPolicy.shouldMarkStale(event.type)) {
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

  Future<InsightsRuntimeSnapshot?> preheat() async {
    final snapshot = await preheater.preheat();
    cache.put(snapshot);
    return snapshot;
  }

  Future<void> _preheatIfNeeded(
    PluginRuntimeContext context, {
    required String reason,
  }) async {
    if (_preheating) return;
    if (!cache.stale && cache.snapshots.isNotEmpty) return;
    _preheating = true;
    try {
      final snapshot = await preheat();
      context.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.custom,
          targetPluginId: pluginId,
          occurredAt: context.now(),
          payload: {
            'name': 'insights.preheated',
            'reason': reason,
            'subjectId': snapshot?.subjectId,
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
