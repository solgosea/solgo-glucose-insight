import 'dart:async';

import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../application/explore_entry_state_refresh_service.dart';
import '../application/explore_runtime_refresh_policy.dart';
import 'explore_entry_state_store.dart';

class ExplorePluginRuntime implements PluginRuntime {
  static const id = PluginId('core.explore');

  final ExploreEntryStateStore store;
  final ExploreEntryStateRefreshService refreshService;
  final ExploreRuntimeRefreshPolicy refreshPolicy;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _refreshing = false;
  bool _refreshAgain = false;

  ExplorePluginRuntime({
    required this.store,
    required this.refreshService,
    this.refreshPolicy = const ExploreRuntimeRefreshPolicy(),
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    _subscription ??= context.eventBus.events.listen((event) {
      if (refreshPolicy.shouldRefresh(event.type)) {
        unawaited(_refresh(context, reason: event.type.name));
      }
    });
    await _refresh(context, reason: 'start');
  }

  @override
  Future<void> resume(PluginRuntimeContext context) {
    return _refresh(context, reason: 'resume');
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {
    // Explore keeps only lightweight entry state.
  }

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> refreshNow(
    PluginRuntimeContext context, {
    String reason = 'manual',
  }) {
    return _refresh(context, reason: reason);
  }

  Future<void> _refresh(
    PluginRuntimeContext context, {
    required String reason,
  }) async {
    if (_refreshing) {
      _refreshAgain = true;
      return;
    }
    _refreshing = true;
    try {
      final snapshot = refreshService.refresh(reason: reason);
      store.update(snapshot);
    } catch (error) {
      context.markFailed(pluginId, error);
    } finally {
      _refreshing = false;
    }
    if (_refreshAgain) {
      _refreshAgain = false;
      await _refresh(context, reason: 'queued');
    }
  }
}
