import 'dart:async';

import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/home_runtime_refresh_policy.dart';
import '../application/home_snapshot_preheater.dart';
import '../models/home_chart_range.dart';
import 'home_runtime_cache.dart';

class HomePluginRuntime implements PluginRuntime {
  static const id = PluginId('core.home');

  final HomeRuntimeCache cache;
  final HomeSnapshotPreheater preheater;
  final HomeRuntimeRefreshPolicy refreshPolicy;
  final HomeChartRange defaultRange;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _preheating = false;
  bool _preheatAgain = false;

  HomePluginRuntime({
    required this.cache,
    required this.preheater,
    this.refreshPolicy = const HomeRuntimeRefreshPolicy(),
    this.defaultRange = HomeChartRange.fourHours,
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
  Future<void> pause(PluginRuntimeContext context) async {
    // Home owns no long-running task. Sync remains owned by datasource runtime.
  }

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<HomeRuntimeSnapshot?> preheatRange({
    required HomeChartRange range,
  }) async {
    final snapshot = await preheater.preheat(range: range);
    cache.put(snapshot);
    return snapshot;
  }

  Future<void> _preheatIfNeeded(
    PluginRuntimeContext context, {
    required String reason,
    bool force = false,
  }) async {
    if (_preheating) {
      _preheatAgain = true;
      return;
    }
    if (!force && !cache.stale && cache.snapshots.isNotEmpty) return;
    _preheating = true;
    try {
      final snapshot = await preheatRange(range: defaultRange);
      context.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.custom,
          targetPluginId: pluginId,
          occurredAt: context.now(),
          payload: {
            'name': 'home.preheated',
            'reason': reason,
            'subjectId': snapshot?.subjectId,
            'range': snapshot?.range.name,
          },
        ),
      );
    } catch (error) {
      cache.markStale('preheatFailed');
      context.markFailed(pluginId, error);
    } finally {
      _preheating = false;
    }
    if (_preheatAgain) {
      _preheatAgain = false;
      cache.markStale(reason);
      await _preheatIfNeeded(context, reason: 'queued', force: true);
    }
  }
}
