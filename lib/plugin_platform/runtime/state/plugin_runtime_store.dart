import 'package:flutter/foundation.dart';

import '../../contracts/plugin_id.dart';
import '../contracts/plugin_runtime_capability.dart';
import '../contracts/plugin_runtime_lifecycle.dart';
import 'plugin_runtime_snapshot.dart';

class PluginRuntimeStore extends ChangeNotifier {
  final Map<PluginId, PluginRuntimeSnapshot> _snapshots = {};
  final DateTime Function() _now;

  PluginRuntimeStore({
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  List<PluginRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  PluginRuntimeSnapshot? snapshotFor(PluginId pluginId) => _snapshots[pluginId];

  void register(
    PluginId pluginId, {
    required PluginRuntimeCapability capability,
  }) {
    _snapshots.putIfAbsent(
      pluginId,
      () => PluginRuntimeSnapshot(
        pluginId: pluginId,
        capability: capability,
        lifecycle: PluginRuntimeLifecycle.idle,
        updatedAt: _now(),
      ),
    );
    notifyListeners();
  }

  void markStarting(PluginId pluginId) {
    _update(pluginId, PluginRuntimeLifecycle.starting, clearMessage: true);
  }

  void markRunning(PluginId pluginId) {
    _update(pluginId, PluginRuntimeLifecycle.running, clearMessage: true);
  }

  void markPaused(PluginId pluginId) {
    _update(pluginId, PluginRuntimeLifecycle.paused, clearMessage: true);
  }

  void markStopped(PluginId pluginId) {
    _update(pluginId, PluginRuntimeLifecycle.stopped, clearMessage: true);
  }

  void markFailed(PluginId pluginId, String message) {
    _update(pluginId, PluginRuntimeLifecycle.failed, message: message);
  }

  void _update(
    PluginId pluginId,
    PluginRuntimeLifecycle lifecycle, {
    String? message,
    bool clearMessage = false,
  }) {
    final current = _snapshots[pluginId];
    if (current == null) return;
    _snapshots[pluginId] = current.copyWith(
      lifecycle: lifecycle,
      message: message,
      clearMessage: clearMessage,
      updatedAt: _now(),
    );
    notifyListeners();
  }
}
