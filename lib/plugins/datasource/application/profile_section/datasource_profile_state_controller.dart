import 'package:smart_xdrip/application/data_source/datasource_profile_section_services.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_event.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_policy.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_reason.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_scope.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_state.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_state_machine.dart';

import 'datasource_profile_initial_state_builder.dart';
import 'datasource_profile_snapshot_loader.dart';
import 'datasource_profile_sync_status_loader.dart';

class DatasourceProfileStateController {
  final DatasourceProfileStateMachine machine;
  final DatasourceProfileInitialStateBuilder initialBuilder;
  final DatasourceProfileSnapshotLoader snapshotLoader;
  final DatasourceProfileSyncStatusLoader syncStatusLoader;
  final DatasourceProfileRefreshPolicy refreshPolicy;

  DatasourceProfileState _state = const DatasourceProfileState.initial();

  DatasourceProfileStateController({
    this.machine = const DatasourceProfileStateMachine(),
    this.initialBuilder = const DatasourceProfileInitialStateBuilder(),
    this.snapshotLoader = const DatasourceProfileSnapshotLoader(),
    this.syncStatusLoader = const DatasourceProfileSyncStatusLoader(),
    this.refreshPolicy = const DatasourceProfileRefreshPolicy(),
  });

  DatasourceProfileState get state => _state;

  DatasourceProfileState buildInitial(
    DatasourceProfileSectionServices services,
  ) {
    final snapshots = initialBuilder.build(
      settings: services.settingsProvider(),
      xdripSupported: services.xdripSupported(),
    );
    _state = machine.reduce(_state, DatasourceProfileShellBuilt(snapshots));
    return _state;
  }

  DatasourceProfileRefreshScope scopeFor(
    DatasourceProfileRefreshReason reason,
  ) {
    return refreshPolicy.scopeFor(reason: reason, state: _state);
  }

  DatasourceProfileState startRefresh({
    required DatasourceProfileRefreshReason reason,
    required DatasourceProfileRefreshScope scope,
  }) {
    _state = machine.reduce(
      _state,
      DatasourceProfileRefreshStarted(reason: reason, scope: scope),
    );
    return _state;
  }

  Future<DatasourceProfileState> loadSnapshots(
    DatasourceProfileSectionServices services,
  ) async {
    try {
      final result = await snapshotLoader.load(services);
      _state = machine.reduce(
        _state,
        DatasourceProfileSnapshotsLoaded(
          snapshots: result.snapshots,
          syncStatus: result.syncStatus,
        ),
      );
      return _state;
    } catch (error) {
      _state = machine.reduce(_state, DatasourceProfileRefreshFailed(error));
      return _state;
    }
  }

  Future<DatasourceProfileState> loadSyncStatus(
    DatasourceProfileSectionServices services,
  ) async {
    try {
      final syncStatus = await syncStatusLoader.load(services);
      _state = machine.reduce(
        _state,
        DatasourceProfileSyncStatusLoaded(syncStatus),
      );
      return _state;
    } catch (error) {
      _state = machine.reduce(_state, DatasourceProfileRefreshFailed(error));
      return _state;
    }
  }
}
