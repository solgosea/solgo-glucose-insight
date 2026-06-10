import 'dart:async';

import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/history_runtime_refresh_policy.dart';
import '../application/history_snapshot_preheater.dart';
import 'history_runtime_cache.dart';

class HistoryPluginRuntime implements PluginRuntime {
  static const id = PluginId('core.history');

  final HistoryRuntimeCache cache;
  final HistorySnapshotPreheater preheater;
  final HistoryRuntimeRefreshPolicy refreshPolicy;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _preheating = false;
  DateTime? _lastRequestedDay;

  HistoryPluginRuntime({
    required this.cache,
    required this.preheater,
    this.refreshPolicy = const HistoryRuntimeRefreshPolicy(),
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

  Future<HistoryRuntimeSnapshot?> preheatDay({required DateTime day}) async {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    _lastRequestedDay = normalizedDay;
    final snapshot = await preheater.preheat(day: normalizedDay);
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
      final requestedDay = _lastRequestedDay ?? context.now();
      final snapshot = await preheatDay(day: requestedDay);
      context.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.custom,
          targetPluginId: pluginId,
          occurredAt: context.now(),
          payload: {
            'name': 'history.preheated',
            'reason': reason,
            'subjectId': snapshot?.query.subjectId,
            'day': snapshot?.query.normalizedDay.toIso8601String(),
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
