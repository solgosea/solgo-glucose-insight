import 'dart:async';

import '../../../../plugin_platform/contracts/plugin_id.dart';
import '../../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/episode_detail_runtime_refresh_policy.dart';
import '../application/episode_detail_snapshot_preheater.dart';
import '../application/text/episode_detail_text_template_installer.dart';
import '../models/episode_kind.dart';
import 'episode_detail_runtime_cache.dart';
import 'episode_detail_runtime_snapshot.dart';

class EpisodeDetailPluginRuntime implements PluginRuntime {
  static const id = PluginId('explore.episode_detail');

  final EpisodeDetailRuntimeCache cache;
  final EpisodeDetailSnapshotPreheater preheater;
  final EpisodeDetailRuntimeRefreshPolicy refreshPolicy;
  final EpisodeDetailTextTemplateInstaller? textTemplateInstaller;
  final List<EpisodeKind> defaultKinds;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _preheating = false;
  bool _preheatAgain = false;

  EpisodeDetailPluginRuntime({
    required this.cache,
    required this.preheater,
    this.textTemplateInstaller,
    this.refreshPolicy = const EpisodeDetailRuntimeRefreshPolicy(),
    this.defaultKinds = const [EpisodeKind.high, EpisodeKind.low],
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.task;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    await textTemplateInstaller?.ensureInstalled();
    _subscription ??= context.eventBus.events.listen((event) {
      if (refreshPolicy.shouldRefresh(event.type)) {
        cache.markStale(event.type.name);
        unawaited(preheatDefaults(context, reason: event.type.name));
        return;
      }
      if (refreshPolicy.shouldMarkStale(event.type)) {
        cache.markStale(event.type.name);
      }
    });
    await preheatDefaults(context, reason: 'start');
  }

  @override
  Future<void> resume(PluginRuntimeContext context) {
    return preheatDefaults(context, reason: 'resume');
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {
    // Episode Detail owns no foreground polling work.
  }

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> preheatDefaults(
    PluginRuntimeContext context, {
    required String reason,
  }) async {
    for (final kind in defaultKinds) {
      await preheatKind(context, kind: kind, reason: reason);
    }
  }

  Future<EpisodeDetailRuntimeSnapshot?> preheatKind(
    PluginRuntimeContext context, {
    required EpisodeKind kind,
    required String reason,
  }) async {
    if (_preheating) {
      _preheatAgain = true;
      return null;
    }
    final cached = cache.freshSnapshot(
      subjectId: preheater.facadeProvider().activeSubject.id,
      kind: kind,
    );
    if (cached != null) return cached;

    _preheating = true;
    try {
      final snapshot = preheater.preheat(kind: kind, reason: reason);
      cache.put(snapshot);
      context.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.custom,
          targetPluginId: pluginId,
          occurredAt: context.now(),
          payload: {
            'name': 'episode_detail.preheated',
            'reason': reason,
            'subjectId': snapshot.subjectId,
            'kind': snapshot.kind.name,
            'hasData': snapshot.output.focus != null,
          },
        ),
      );
      return snapshot;
    } catch (error) {
      cache.markStale('preheatFailed');
      context.markFailed(pluginId, error);
      return null;
    } finally {
      _preheating = false;
      if (_preheatAgain) {
        _preheatAgain = false;
        unawaited(preheatKind(context, kind: kind, reason: 'queued'));
      }
    }
  }
}
