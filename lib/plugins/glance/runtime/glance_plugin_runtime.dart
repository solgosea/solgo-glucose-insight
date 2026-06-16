import 'dart:async';

import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/glance_persistent_notification_service.dart';
import '../application/glance_runtime_coordinator.dart';

class GlancePluginRuntime implements PluginRuntime {
  static const runtimeId = PluginId('glance.layer');

  final GlanceRuntimeCoordinator coordinator;
  final GlancePersistentNotificationService notificationService;
  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _refreshing = false;
  bool _refreshAgain = false;

  GlancePluginRuntime({
    required this.coordinator,
    required this.notificationService,
  });

  @override
  PluginId get pluginId => runtimeId;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    await notificationService.initialize();
    _subscription ??= context.eventBus.events.listen((event) {
      if (_shouldRefresh(event.type)) {
        unawaited(_refreshSafely(context, reason: event.type.name));
      }
    });
    await _refreshSafely(context, reason: 'start', force: true);
  }

  @override
  Future<void> resume(PluginRuntimeContext context) {
    return _refreshSafely(context, reason: 'resume', force: true);
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {}

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
  }

  bool _shouldRefresh(PluginRuntimeEventType type) {
    return type == PluginRuntimeEventType.subjectDataChanged ||
        type == PluginRuntimeEventType.activeSubjectChanged ||
        type == PluginRuntimeEventType.settingsChanged ||
        type == PluginRuntimeEventType.datasourceChanged ||
        type == PluginRuntimeEventType.appResumed;
  }

  Future<void> _refreshSafely(
    PluginRuntimeContext context, {
    required String reason,
    bool force = false,
  }) async {
    if (_refreshing) {
      _refreshAgain = true;
      return;
    }
    _refreshing = true;
    try {
      await coordinator.refresh(reason: reason, force: force);
    } catch (error) {
      context.markFailed(pluginId, error);
    } finally {
      _refreshing = false;
    }
    if (_refreshAgain) {
      _refreshAgain = false;
      await _refreshSafely(context, reason: 'queued', force: true);
    }
  }
}
