import 'dart:async';

import '../../domain/data_source/data_source_kind.dart';
import '../../domain/data_source_runtime/data_source_health_status.dart';
import '../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/source_sync_state.dart';
import 'handlers/data_source_health_handler.dart';
import 'handlers/nightscout_health_handler.dart';
import 'handlers/xdrip_local_health_handler.dart';

typedef SourceSyncStateLoader =
    Future<SourceSyncState?> Function(DataSourceKind kind);

class DataSourceRuntimeCoordinator {
  final SourceSyncStateLoader syncStateLoader;
  final List<DataSourceHealthHandler> handlers;
  final bool xdripSupported;
  final Duration interval;

  final Map<DataSourceKind, DataSourceRuntimeSnapshot> _snapshots = {};
  Timer? _timer;
  AppSettings? _settings;

  DataSourceRuntimeCoordinator({
    required this.syncStateLoader,
    required this.xdripSupported,
    this.interval = const Duration(seconds: 45),
    this.handlers = const [
      XdripLocalHealthHandler(),
      NightscoutHealthHandler(),
    ],
  });

  List<DataSourceRuntimeSnapshot> get snapshots =>
      DataSourceKind.values.map(snapshotFor).toList();

  DataSourceRuntimeSnapshot snapshotFor(DataSourceKind kind) {
    return _snapshots[kind] ?? _defaultSnapshot(kind);
  }

  Future<void> start(AppSettings settings) async {
    _settings = settings;
    await refresh(settings: settings);
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      final current = _settings;
      if (current != null) refresh(settings: current);
    });
  }

  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
    await refresh(settings: settings);
  }

  Future<void> refresh({AppSettings? settings}) async {
    final current = settings ?? _settings;
    if (current == null) return;
    _settings = current;
    for (final handler in handlers) {
      await refreshOne(handler.kind, settings: current);
    }
  }

  Future<DataSourceRuntimeSnapshot> refreshOne(
    DataSourceKind kind, {
    AppSettings? settings,
  }) async {
    final current = settings ?? _settings;
    if (current == null) return snapshotFor(kind);
    _settings = current;

    final handler = _handlerFor(kind);
    final syncState = await syncStateLoader(kind);
    final supported = _supported(kind);
    if (!supported) {
      return _store(
        DataSourceRuntimeSnapshot(
          kind: kind,
          healthStatus: DataSourceHealthStatus.unsupported,
          supported: false,
          configured: false,
          active: _active(current, kind),
          syncState: syncState,
        ),
      );
    }

    final configured = handler.isConfigured(current);
    if (!configured) {
      return _store(
        DataSourceRuntimeSnapshot(
          kind: kind,
          healthStatus: DataSourceHealthStatus.notConfigured,
          supported: true,
          configured: false,
          active: _active(current, kind),
          syncState: syncState,
        ),
      );
    }

    _store(
      DataSourceRuntimeSnapshot(
        kind: kind,
        healthStatus: DataSourceHealthStatus.checking,
        supported: true,
        configured: true,
        active: _active(current, kind),
        lastCheckedAt: DateTime.now(),
        syncState: syncState,
      ),
    );

    final result = await handler.check(current);
    return _store(
      DataSourceRuntimeSnapshot(
        kind: kind,
        healthStatus:
            result.success
                ? DataSourceHealthStatus.reachable
                : DataSourceHealthStatus.unreachable,
        supported: true,
        configured: true,
        active: _active(current, kind),
        lastCheckedAt: DateTime.now(),
        lastHealthMessage: result.message,
        syncState: await syncStateLoader(kind),
      ),
    );
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  DataSourceRuntimeSnapshot _store(DataSourceRuntimeSnapshot snapshot) {
    _snapshots[snapshot.kind] = snapshot;
    return snapshot;
  }

  DataSourceRuntimeSnapshot _defaultSnapshot(DataSourceKind kind) {
    return DataSourceRuntimeSnapshot(
      kind: kind,
      healthStatus:
          _supported(kind)
              ? DataSourceHealthStatus.unchecked
              : DataSourceHealthStatus.unsupported,
      supported: _supported(kind),
      configured: false,
      active: false,
    );
  }

  DataSourceHealthHandler _handlerFor(DataSourceKind kind) {
    return handlers.firstWhere((handler) => handler.kind == kind);
  }

  bool _supported(DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => xdripSupported,
      DataSourceKind.nightscout => true,
    };
  }

  bool _active(AppSettings settings, DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => settings.xdripSyncEnabled,
      DataSourceKind.nightscout => settings.nightscoutSyncEnabled,
    };
  }
}
