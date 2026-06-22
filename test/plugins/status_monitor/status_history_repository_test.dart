import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sqlite/status_monitor_repository.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_component_history_sample.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_query.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_sample_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_scope.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/history/status_history_window.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database database;
  late StatusMonitorRepository repository;

  setUp(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    repository =
        StatusMonitorRepository(databaseProvider: () async => database);
  });

  tearDown(() async {
    await database.close();
  });

  test('queryHistory scopes by subject, source target, and time window',
      () async {
    final now = DateTime.utc(2026, 6, 12, 12);
    await repository.insertHistorySample(
      subjectId: 'self',
      sample: _sample(
        now.subtract(const Duration(hours: 2)),
        StatusLevel.watch,
        sourceTargetId: 'nightscout',
      ),
    );
    await repository.insertHistorySample(
      subjectId: 'self',
      sample: _sample(
        now.subtract(const Duration(hours: 1)),
        StatusLevel.issue,
        sourceTargetId: 'xdrip_local',
      ),
    );
    await repository.insertHistorySample(
      subjectId: 'child',
      sample: _sample(
        now.subtract(const Duration(minutes: 30)),
        StatusLevel.healthy,
        sourceTargetId: 'nightscout',
      ),
    );
    await repository.insertHistorySample(
      subjectId: 'self',
      sample: _sample(
        now.subtract(const Duration(days: 8)),
        StatusLevel.issue,
        sourceTargetId: 'nightscout',
      ),
    );

    final samples = await repository.queryHistorySamples(
      StatusHistoryQuery(
        scope: const StatusHistoryScope(
          subjectId: 'self',
          sourceTargetId: 'nightscout',
        ),
        window: StatusHistoryWindow.lastSevenDays(now),
      ),
    );

    expect(samples, hasLength(1));
    expect(samples.single.level, StatusLevel.watch);
    expect(samples.single.score, 72);
    expect(samples.single.confidence, .8);
    expect(samples.single.source.label, 'Nightscout');
  });

  test('queryHistory does not mix source-scoped and source-agnostic rows',
      () async {
    final now = DateTime.utc(2026, 6, 12, 12);
    await repository.insertHistorySample(
      subjectId: 'self',
      sample: _sample(
        now.subtract(const Duration(hours: 2)),
        StatusLevel.watch,
        sourceTargetId: null,
      ),
    );
    await repository.insertHistorySample(
      subjectId: 'self',
      sample: _sample(
        now.subtract(const Duration(hours: 1)),
        StatusLevel.issue,
        sourceTargetId: 'nightscout',
      ),
    );

    final points = await repository.queryHistory(
      StatusHistoryQuery(
        scope: const StatusHistoryScope(
          subjectId: 'self',
          sourceTargetId: 'nightscout',
        ),
        window: StatusHistoryWindow.lastSevenDays(now),
      ),
    );

    expect(points.map((point) => point.level), [StatusLevel.issue]);
  });
}

StatusComponentHistorySample _sample(
  DateTime at,
  StatusLevel level, {
  required String? sourceTargetId,
}) {
  return StatusComponentHistorySample(
    at: at,
    component: StatusComponentKind.xdrip,
    level: level,
    score: 72,
    confidence: .8,
    summary: level.label,
    source: StatusHistorySampleSource(
      targetId: sourceTargetId,
      kind: sourceTargetId ?? 'local',
      label: sourceTargetId == 'nightscout' ? 'Nightscout' : 'xDrip+ Local',
    ),
  );
}
