import 'package:smart_xdrip/application/data_source/datasource_profile_section_services.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';

class DatasourceProfileSnapshotLoadResult {
  final List<DataSourceConnectionSnapshot> snapshots;
  final SyncStatusSnapshot syncStatus;

  const DatasourceProfileSnapshotLoadResult({
    required this.snapshots,
    required this.syncStatus,
  });
}

class DatasourceProfileSnapshotLoader {
  const DatasourceProfileSnapshotLoader();

  Future<DatasourceProfileSnapshotLoadResult> load(
    DatasourceProfileSectionServices services,
  ) async {
    final syncStatusFuture = services.syncStatusSnapshot();
    final snapshotsFuture = services.dataSourceSnapshots(
      xdripSupported: services.xdripSupported(),
    );
    final results = await Future.wait<Object>([
      syncStatusFuture,
      snapshotsFuture,
    ]);
    return DatasourceProfileSnapshotLoadResult(
      syncStatus: results[0] as SyncStatusSnapshot,
      snapshots: results[1] as List<DataSourceConnectionSnapshot>,
    );
  }
}
