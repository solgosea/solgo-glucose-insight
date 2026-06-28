import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/datasource/application/profile_section/datasource_profile_initial_state_builder.dart';

void main() {
  const builder = DatasourceProfileInitialStateBuilder();

  test('builds visible rows immediately from settings', () {
    final snapshots = builder.build(
      settings: const AppSettings(),
      xdripSupported: true,
    );

    expect(snapshots, hasLength(2));
    expect(snapshots.map((snapshot) => snapshot.kind), [
      DataSourceKind.xdripLocal,
      DataSourceKind.nightscout,
    ]);
    expect(snapshots.last.status, DataSourceConnectionStatus.notConfigured);
    expect(snapshots.last.action, DataSourceConnectionAction.none);
  });

  test('configured active nightscout starts as checking shell', () {
    final snapshots = builder.build(
      settings: const AppSettings(
        nightscoutBaseUrl: 'http://example.test',
        nightscoutSyncEnabled: true,
      ),
      xdripSupported: true,
    );

    final nightscout = snapshots.last;
    expect(nightscout.active, isTrue);
    expect(nightscout.configured, isTrue);
    expect(nightscout.status, DataSourceConnectionStatus.connecting);
  });
}
