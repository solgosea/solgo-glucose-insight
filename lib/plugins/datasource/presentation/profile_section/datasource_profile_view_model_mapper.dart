import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_section_phase.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_state.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model_mapper.dart';

import 'datasource_profile_view_model.dart';

class DatasourceProfileViewModelMapper {
  final SyncStatusViewModelMapper syncStatusMapper;

  const DatasourceProfileViewModelMapper({
    this.syncStatusMapper = const SyncStatusViewModelMapper(),
  });

  DatasourceProfileViewModel map({
    required List<DataSourceConnectionSnapshot> snapshots,
    SyncStatusSnapshot? syncStatus,
    SyncRuntimeStatus? syncRuntimeStatus,
    bool refreshing = false,
    String? recoverableErrorText,
  }) {
    return DatasourceProfileViewModel(
      sources: snapshots
          .map(
            (snapshot) => DatasourceProfileSourceViewModel(
              kind: snapshot.kind,
              action: snapshot.action,
              strategyAction: snapshot.strategyAction,
              actionStyle: _actionStyle(snapshot.action),
              name: snapshot.title,
              subtitle: snapshot.subtitle,
              meta: _sourceMeta(snapshot),
              syncStatus: syncStatus == null
                  ? null
                  : _sourceSyncStatus(
                      snapshot,
                      syncStatus: syncStatus,
                      syncRuntimeStatus: syncRuntimeStatus,
                    ),
              trailing: snapshot.trailing,
              secondaryTrailing:
                  snapshot.kind == DataSourceKind.nightscout ? 'Edit' : null,
              secondaryAction: snapshot.kind == DataSourceKind.nightscout
                  ? DataSourceConnectionAction.configure
                  : null,
              statusColor: _statusColor(snapshot),
              active: snapshot.active,
              actionEnabled: snapshot.action != DataSourceConnectionAction.none,
              strategyActionEnabled:
                  snapshot.strategyAction != DataSourceSyncStrategyAction.none,
              pulsing: snapshot.status == DataSourceConnectionStatus.syncing ||
                  snapshot.status == DataSourceConnectionStatus.connecting,
              checking:
                  snapshot.status == DataSourceConnectionStatus.connecting,
              muted: _muted(snapshot),
            ),
          )
          .toList(growable: false),
      runtimeLimitationText: '',
      foregroundReconcileLabel: '',
      refreshing: refreshing,
      recoverableErrorText: recoverableErrorText,
    );
  }

  DatasourceProfileViewModel mapState({
    required DatasourceProfileState state,
    SyncRuntimeStatus? syncRuntimeStatus,
  }) {
    return map(
      snapshots: state.snapshots,
      syncStatus: state.syncStatus,
      syncRuntimeStatus: syncRuntimeStatus,
      refreshing: state.refreshing,
      recoverableErrorText:
          state.phase == DatasourceProfileSectionPhase.errorRecoverable
              ? 'Could not refresh data source status'
              : null,
    );
  }

  Color _statusColor(DataSourceConnectionSnapshot snapshot) {
    return switch (snapshot.status) {
      DataSourceConnectionStatus.detected ||
      DataSourceConnectionStatus.syncing ||
      DataSourceConnectionStatus.connecting =>
        AppColors.green,
      DataSourceConnectionStatus.connected ||
      DataSourceConnectionStatus.configured =>
        AppColors.amber,
      DataSourceConnectionStatus.failed => AppColors.rose,
      _ => AppColors.textDim,
    };
  }

  bool _muted(DataSourceConnectionSnapshot snapshot) {
    return switch (snapshot.status) {
      DataSourceConnectionStatus.notDetected ||
      DataSourceConnectionStatus.notConfigured ||
      DataSourceConnectionStatus.unsupported =>
        true,
      _ => false,
    };
  }

  DatasourceProfileActionStyle _actionStyle(
    DataSourceConnectionAction action,
  ) {
    return switch (action) {
      DataSourceConnectionAction.connect ||
      DataSourceConnectionAction.configure ||
      DataSourceConnectionAction.sync =>
        DatasourceProfileActionStyle.primary,
      DataSourceConnectionAction.use => DatasourceProfileActionStyle.secondary,
      DataSourceConnectionAction.detect => DatasourceProfileActionStyle.warning,
      DataSourceConnectionAction.disconnect =>
        DatasourceProfileActionStyle.destructive,
      DataSourceConnectionAction.none => DatasourceProfileActionStyle.disabled,
    };
  }

  String? _sourceMeta(DataSourceConnectionSnapshot snapshot) {
    final state = snapshot.syncState;
    if (snapshot.status == DataSourceConnectionStatus.connecting) {
      return 'Checking source...';
    }
    if (snapshot.active) return null;
    if (!snapshot.active &&
        snapshot.status == DataSourceConnectionStatus.failed) {
      return 'Connection check failed';
    }
    if (!(snapshot.configured || snapshot.detected)) return 'Not configured';
    if (state?.lastError != null) return 'Last sync failed';
    if (state?.lastSuccessAt == null) return 'Waiting for first sync';
    return null;
  }

  SyncStatusViewModel? _sourceSyncStatus(
    DataSourceConnectionSnapshot snapshot, {
    required SyncStatusSnapshot syncStatus,
    SyncRuntimeStatus? syncRuntimeStatus,
  }) {
    if (!snapshot.active) return null;
    if (!syncStatus.active) return null;
    if (syncStatus.sourceLabel != snapshot.title &&
        syncStatus.sourceLabel != 'Data sources') {
      return null;
    }
    return syncStatusMapper.map(syncStatus, runtimeStatus: syncRuntimeStatus);
  }
}
