import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';

import 'datasource_profile_refresh_reason.dart';
import 'datasource_profile_refresh_scope.dart';

sealed class DatasourceProfileEvent {
  const DatasourceProfileEvent();
}

class DatasourceProfileShellBuilt extends DatasourceProfileEvent {
  final List<DataSourceConnectionSnapshot> snapshots;

  const DatasourceProfileShellBuilt(this.snapshots);
}

class DatasourceProfileRefreshStarted extends DatasourceProfileEvent {
  final DatasourceProfileRefreshReason reason;
  final DatasourceProfileRefreshScope scope;

  const DatasourceProfileRefreshStarted({
    required this.reason,
    required this.scope,
  });
}

class DatasourceProfileSnapshotsLoaded extends DatasourceProfileEvent {
  final List<DataSourceConnectionSnapshot> snapshots;
  final SyncStatusSnapshot syncStatus;

  const DatasourceProfileSnapshotsLoaded({
    required this.snapshots,
    required this.syncStatus,
  });
}

class DatasourceProfileSyncStatusLoaded extends DatasourceProfileEvent {
  final SyncStatusSnapshot syncStatus;

  const DatasourceProfileSyncStatusLoaded(this.syncStatus);
}

class DatasourceProfileRefreshFailed extends DatasourceProfileEvent {
  final Object error;

  const DatasourceProfileRefreshFailed(this.error);
}
