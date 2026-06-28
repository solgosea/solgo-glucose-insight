import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_policy.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_reason.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_scope.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_section_phase.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_state.dart';

void main() {
  const policy = DatasourceProfileRefreshPolicy();

  test('empty state requires source configuration shell', () {
    final scope = policy.scopeFor(
      reason: DatasourceProfileRefreshReason.syncStatusChanged,
      state: const DatasourceProfileState.initial(),
    );

    expect(scope, DatasourceProfileRefreshScope.sourceConfiguration);
  });

  test('runtime ticks update sync status only', () {
    final scope = policy.scopeFor(
      reason: DatasourceProfileRefreshReason.runtimeTick,
      state: _readyState,
    );

    expect(scope, DatasourceProfileRefreshScope.syncStatusOnly);
  });

  test('host changes refresh full snapshot without rebuilding shell', () {
    final scope = policy.scopeFor(
      reason: DatasourceProfileRefreshReason.hostChanged,
      state: _readyState,
    );

    expect(scope, DatasourceProfileRefreshScope.fullSnapshot);
  });
}

const _readyState = DatasourceProfileState(
  phase: DatasourceProfileSectionPhase.ready,
  snapshots: [
    DataSourceConnectionSnapshot(
      kind: DataSourceKind.nightscout,
      status: DataSourceConnectionStatus.configured,
      action: DataSourceConnectionAction.none,
      strategyAction: DataSourceSyncStrategyAction.disable,
      title: 'Nightscout API',
      subtitle: 'Configured',
      trailing: 'Configured',
      strategyTrailing: 'Disable',
      active: true,
      detected: true,
      configured: true,
      strategyEnabled: true,
      supported: true,
    ),
  ],
);
