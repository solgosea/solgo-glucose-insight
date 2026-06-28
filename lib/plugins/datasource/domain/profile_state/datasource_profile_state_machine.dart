import 'datasource_profile_event.dart';
import 'datasource_profile_refresh_scope.dart';
import 'datasource_profile_section_phase.dart';
import 'datasource_profile_state.dart';

class DatasourceProfileStateMachine {
  const DatasourceProfileStateMachine();

  DatasourceProfileState reduce(
    DatasourceProfileState state,
    DatasourceProfileEvent event,
  ) {
    return switch (event) {
      DatasourceProfileShellBuilt(:final snapshots) => state.copyWith(
          phase: DatasourceProfileSectionPhase.ready,
          snapshots: snapshots,
          refreshing: false,
          clearSyncStatus: true,
          clearLastError: true,
        ),
      DatasourceProfileRefreshStarted(:final scope) => state.copyWith(
          phase: state.snapshots.isEmpty
              ? DatasourceProfileSectionPhase.initializing
              : DatasourceProfileSectionPhase.refreshing,
          refreshing: true,
          clearSyncStatus:
              scope == DatasourceProfileRefreshScope.sourceConfiguration &&
                  state.snapshots.isEmpty,
          clearLastError: true,
        ),
      DatasourceProfileSnapshotsLoaded(
        :final snapshots,
        :final syncStatus,
      ) =>
        state.copyWith(
          phase: DatasourceProfileSectionPhase.ready,
          snapshots: snapshots,
          syncStatus: syncStatus,
          refreshing: false,
          clearLastError: true,
        ),
      DatasourceProfileSyncStatusLoaded(:final syncStatus) => state.copyWith(
          phase: DatasourceProfileSectionPhase.ready,
          syncStatus: syncStatus,
          refreshing: false,
          clearLastError: true,
        ),
      DatasourceProfileRefreshFailed(:final error) => state.copyWith(
          phase: state.snapshots.isEmpty
              ? DatasourceProfileSectionPhase.initializing
              : DatasourceProfileSectionPhase.errorRecoverable,
          refreshing: false,
          lastError: error,
        ),
    };
  }
}
