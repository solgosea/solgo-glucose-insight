import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';

import 'datasource_profile_section_phase.dart';

class DatasourceProfileState {
  final DatasourceProfileSectionPhase phase;
  final List<DataSourceConnectionSnapshot> snapshots;
  final SyncStatusSnapshot? syncStatus;
  final bool refreshing;
  final Object? lastError;

  const DatasourceProfileState({
    required this.phase,
    required this.snapshots,
    this.syncStatus,
    this.refreshing = false,
    this.lastError,
  });

  const DatasourceProfileState.initial()
      : phase = DatasourceProfileSectionPhase.initializing,
        snapshots = const [],
        syncStatus = null,
        refreshing = false,
        lastError = null;

  DatasourceProfileState copyWith({
    DatasourceProfileSectionPhase? phase,
    List<DataSourceConnectionSnapshot>? snapshots,
    SyncStatusSnapshot? syncStatus,
    bool? clearSyncStatus,
    bool? refreshing,
    Object? lastError,
    bool clearLastError = false,
  }) {
    return DatasourceProfileState(
      phase: phase ?? this.phase,
      snapshots: snapshots ?? this.snapshots,
      syncStatus:
          clearSyncStatus == true ? null : syncStatus ?? this.syncStatus,
      refreshing: refreshing ?? this.refreshing,
      lastError: clearLastError ? null : lastError ?? this.lastError,
    );
  }
}
