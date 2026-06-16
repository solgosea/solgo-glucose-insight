import 'dart:async';

import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../application/statistics_runtime_refresh_policy.dart';
import '../application/statistics_snapshot_preheater.dart';
import '../application/statistics_window_policy.dart';
import '../application/text/statistics_text_template_installer.dart';
import 'statistics_runtime_cache.dart';

class StatisticsPluginRuntime implements PluginRuntime {
  static const id = PluginId('core.statistics');

  final StatisticsRuntimeCache cache;
  final StatisticsSnapshotPreheater preheater;
  final StatisticsRuntimeRefreshPolicy refreshPolicy;
  final StatisticsTextTemplateInstaller? textTemplateInstaller;
  final StatisticsWindowPolicy windowPolicy;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _preheating = false;
  late StatisticsAnalysisWindowId _lastRequestedWindowId =
      windowPolicy.defaultWindowId;

  StatisticsPluginRuntime({
    required this.cache,
    required this.preheater,
    this.textTemplateInstaller,
    this.refreshPolicy = const StatisticsRuntimeRefreshPolicy(),
    this.windowPolicy = const StatisticsWindowPolicy(),
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    await textTemplateInstaller?.ensureInstalled();
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

  Future<StatisticsRuntimeSnapshot?> preheatWindow({
    required StatisticsAnalysisWindowId windowId,
  }) async {
    _lastRequestedWindowId = windowId;
    final snapshot = await preheater.preheat(windowId: windowId);
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
      final snapshot = await preheatWindow(
        windowId: _lastRequestedWindowId,
      );
      context.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.custom,
          targetPluginId: pluginId,
          occurredAt: context.now(),
          payload: {
            'name': 'statistics.preheated',
            'reason': reason,
            'subjectId': snapshot?.query.subjectId,
            'windowId': snapshot?.query.windowId.code,
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
