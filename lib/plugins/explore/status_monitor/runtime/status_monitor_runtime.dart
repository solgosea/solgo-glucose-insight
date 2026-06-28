import 'dart:async';

import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';

import '../application/status_monitor_refresh_coordinator.dart';
import '../application/status_monitor_check_service.dart';
import '../application/text/status_text_template_installer.dart';
import 'status_monitor_polling_runtime_binding.dart';
import 'status_monitor_runtime_cache.dart';

class StatusMonitorRuntime implements PluginRuntime {
  static const id = PluginId('explore.statusMonitor');

  final StatusMonitorRefreshCoordinator refreshCoordinator;
  final StatusMonitorCheckService checkService;
  final StatusMonitorRuntimeCache cache;
  final StatusTextTemplateInstaller textTemplateInstaller;
  final StatusMonitorPollingRuntimeBinding? pollingBinding;
  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _refreshing = false;
  bool _queued = false;

  StatusMonitorRuntime({
    required this.refreshCoordinator,
    required this.checkService,
    required this.cache,
    required this.textTemplateInstaller,
    this.pollingBinding,
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    await textTemplateInstaller.ensureInstalled();
    await refreshCoordinator.initialize();
    _subscription ??= context.eventBus.events.listen((event) {
      if (_shouldRefresh(event.type)) {
        unawaited(_refresh(context));
      }
    });
    pollingBinding?.start();
    await _refresh(context);
  }

  @override
  Future<void> resume(PluginRuntimeContext context) => _refresh(context);

  @override
  Future<void> pause(PluginRuntimeContext context) async {}

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
    pollingBinding?.stop();
  }

  bool _shouldRefresh(PluginRuntimeEventType type) {
    return type == PluginRuntimeEventType.subjectDataChanged ||
        type == PluginRuntimeEventType.activeSubjectChanged ||
        type == PluginRuntimeEventType.datasourceChanged ||
        type == PluginRuntimeEventType.appResumed ||
        type == PluginRuntimeEventType.settingsChanged;
  }

  Future<void> _refresh(PluginRuntimeContext context) async {
    if (_refreshing) {
      _queued = true;
      return;
    }
    _refreshing = true;
    cache.markLoading(subjectId: refreshCoordinator.currentSubjectId);
    try {
      await for (final update in checkService.startFreshSession()) {
        cache.updateSession(update.state);
        final report = update.report;
        if (report != null) {
          await refreshCoordinator.publish(report);
          cache.update(report);
        }
      }
    } catch (error) {
      cache.markError(error);
      context.markFailed(pluginId, error);
    } finally {
      _refreshing = false;
    }
    if (_queued) {
      _queued = false;
      await _refresh(context);
    }
  }
}
