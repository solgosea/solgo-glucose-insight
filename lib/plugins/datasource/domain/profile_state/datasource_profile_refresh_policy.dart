import 'datasource_profile_refresh_reason.dart';
import 'datasource_profile_refresh_scope.dart';
import 'datasource_profile_state.dart';

class DatasourceProfileRefreshPolicy {
  const DatasourceProfileRefreshPolicy();

  DatasourceProfileRefreshScope scopeFor({
    required DatasourceProfileRefreshReason reason,
    required DatasourceProfileState state,
  }) {
    if (state.snapshots.isEmpty) {
      return DatasourceProfileRefreshScope.sourceConfiguration;
    }
    return switch (reason) {
      DatasourceProfileRefreshReason.initial ||
      DatasourceProfileRefreshReason.configurationChanged ||
      DatasourceProfileRefreshReason.sourceActionCompleted =>
        DatasourceProfileRefreshScope.sourceConfiguration,
      DatasourceProfileRefreshReason.syncStatusChanged ||
      DatasourceProfileRefreshReason.runtimeTick =>
        DatasourceProfileRefreshScope.syncStatusOnly,
      DatasourceProfileRefreshReason.hostChanged ||
      DatasourceProfileRefreshReason.manual =>
        DatasourceProfileRefreshScope.fullSnapshot,
    };
  }
}
