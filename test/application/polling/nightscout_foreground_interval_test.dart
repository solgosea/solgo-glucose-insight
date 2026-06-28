import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/polling/polling_context_builder.dart';
import 'package:smart_xdrip/application/polling/polling_decision_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';
import 'package:smart_xdrip/domain/polling/polling_mode.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../../_support/test_database.dart';

void main() {
  test('Nightscout foreground normal polling uses configured sync interval',
      () async {
    final database = TestDatabase.create();
    addTearDown(database.close);
    final now = DateTime.now();
    await database.upsertMany(
      [
        GlucoseReading(
          timestamp: now.subtract(const Duration(minutes: 2)),
          value: 6.4,
        ),
      ],
      source: DataSource.nightscout.name,
    );
    await database.recordSourceSuccess(DataSource.nightscout.name);

    final service = PollingDecisionService(
      contextBuilder: PollingContextBuilder(
        database: database,
        sourceStateLoader: (kind) => _sourceStateFor(database, kind),
      ),
    );

    final decision = await service.decide(
      settings: const AppSettings(
        nightscoutBaseUrl: 'http://localhost:1337',
        nightscoutSyncEnabled: true,
        syncIntervalMinutes: 3,
      ),
      mode: PollingMode.foreground,
    );

    expect(decision.nextInterval, const Duration(minutes: 3));
    expect(decision.reason, 'Foreground normal polling');
  });
}

Future<SourceSyncState?> _sourceStateFor(
  GlucoseDatabase database,
  DataSourceKind kind,
) {
  return switch (kind) {
    DataSourceKind.xdripLocal => database.getSourceState(
        DataSource.xdripHttp.name,
      ),
    DataSourceKind.nightscout => database.getSourceState(
        DataSource.nightscout.name,
      ),
  };
}
