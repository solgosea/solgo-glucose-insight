import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/history/status_history_recorder.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sqlite/status_monitor_repository.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/scoring/status_component_score.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';
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

  test('records one history sample per component on every refresh', () async {
    final recorder = StatusHistoryRecorder(repository: repository);
    final now = DateTime.utc(2026, 6, 12, 10);
    await recorder.record(_report(now));
    final later = now.add(const Duration(minutes: 5));
    await recorder.record(_report(later));

    final samples = await repository.queryHistorySamples(
      recorder.queryBuilder.fromReport(_report(later), later),
    );

    expect(samples, hasLength(8));
    expect(
      samples.where((sample) => sample.component == StatusComponentKind.xdrip),
      hasLength(2),
    );
    expect(samples.first.score, 88);
    expect(samples.first.confidence, .75);
    expect(samples.first.source.kind, 'nightscout');
  });
}

StatusReport _report(DateTime generatedAt) {
  return StatusReport(
    subjectId: 'self',
    sourceTargetId: 'nightscout',
    sourceKind: 'nightscout',
    sourceLabel: 'Nightscout',
    generatedAt: generatedAt,
    summary: const StatusSummary(
      level: StatusLevel.healthy,
      headline: 'healthy',
      body: 'body',
      meta: 'meta',
      healthyCount: 4,
      totalCount: 4,
    ),
    components: [
      _component(StatusComponentKind.cgmSensor),
      _component(StatusComponentKind.xdrip),
      _component(StatusComponentKind.nightscout),
      _component(StatusComponentKind.aapsLoop),
    ],
    recentEvents: const [],
    capabilities: const StatusSourceCapabilities.nightscout(),
    hasConfiguredSource: true,
  );
}

ComponentHealth _component(StatusComponentKind kind) {
  return ComponentHealth(
    kind: kind,
    level: StatusLevel.healthy,
    title: kind.title,
    role: kind.role,
    takeaway: 'Healthy',
    summary: 'Healthy',
    metrics: const [],
    score: const StatusComponentScore(
      value: 88,
      label: 'Healthy',
      confidence: .75,
      availableSignals: 4,
      totalSignals: 4,
    ),
  );
}
