import 'package:smart_xdrip/application/data_source/datasource_profile_section_services.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';

class DatasourceProfileSyncStatusLoader {
  const DatasourceProfileSyncStatusLoader();

  Future<SyncStatusSnapshot> load(
    DatasourceProfileSectionServices services,
  ) {
    return services.syncStatusSnapshot();
  }
}
