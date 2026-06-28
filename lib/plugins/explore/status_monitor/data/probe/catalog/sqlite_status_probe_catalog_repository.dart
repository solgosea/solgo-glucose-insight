import 'package:sqflite/sqflite.dart';

import '../../../application/probe/catalog/status_probe_catalog_repository.dart';
import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe/status_probe_display_definition.dart';
import '../../../domain/probe/status_probe_kind.dart';
import '../../../domain/probe/status_probe_path_role.dart';
import '../../../domain/probe/status_probe_score_scope.dart';
import '../../../domain/probe_scenario/status_probe_scenario_definition.dart';
import '../../sqlite/status_monitor_schema.dart';
import '../../sqlite/status_monitor_tables.dart';

class SqliteStatusProbeCatalogRepository
    implements StatusProbeCatalogRepository {
  final Future<Database> Function() databaseProvider;
  bool _schemaReady = false;

  SqliteStatusProbeCatalogRepository({
    required this.databaseProvider,
  });

  Future<Database> get _database async {
    final database = await databaseProvider();
    if (!_schemaReady) {
      await const StatusMonitorSchema().install(database);
      _schemaReady = true;
    }
    return database;
  }

  @override
  Future<void> installDefault(StatusProbeCatalog catalog) async {
    final database = await _database;
    await database.transaction((txn) async {
      await _pruneStaleCatalogRows(txn, catalog);
      for (final suite in catalog.suites) {
        await txn.insert(
          StatusMonitorTables.probeCatalogSuites,
          {
            'suite_id': suite.suiteId,
            'kind': suite.kind.name,
            'title_key': suite.display.titleKey,
            'description_key': suite.display.descriptionKey,
            'icon_key': suite.display.iconKey,
            'role': suite.role.name,
            'score_scope': suite.scoreScope.name,
            'priority': suite.priority,
            'enabled': suite.enabled ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      for (final probe in catalog.probes) {
        await txn.insert(
          StatusMonitorTables.probeCatalogProbes,
          {
            'probe_id': probe.probeId,
            'suite_id': probe.suiteId,
            'driver_id': probe.driverId,
            'title_key': probe.display.titleKey,
            'description_key': probe.display.descriptionKey,
            'icon_key': probe.display.iconKey,
            'guide_route': probe.display.guideRoute,
            'role': probe.role.name,
            'score_scope': probe.scoreScope.name,
            'required': probe.required ? 1 : 0,
            'activation_probe': probe.activationProbe ? 1 : 0,
            'priority': probe.priority,
            'enabled': probe.enabled ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      for (final scenario in catalog.scenarios) {
        await txn.insert(
          StatusMonitorTables.probeScenarios,
          {
            'scenario_id': scenario.id,
            'title_key': scenario.titleKey,
            'description_key': scenario.descriptionKey,
            'enabled': 1,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        for (final item in scenario.items) {
          await txn.insert(
            StatusMonitorTables.probeScenarioItems,
            {
              'scenario_id': scenario.id,
              'suite_id': item.suiteId,
              'probe_id': item.probeId ?? '',
              'section_id': item.sectionId,
              'order_index': item.orderIndex,
              'enabled': item.enabled ? 1 : 0,
              'weight': item.weight,
              'score_scope': item.scoreScope?.name,
              'hard_gate': item.hardGate ? 1 : 0,
              'activation_probe': item.activationProbe ? 1 : 0,
              'score_cap': item.scoreCap,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
  }

  Future<void> _pruneStaleCatalogRows(
    Transaction txn,
    StatusProbeCatalog catalog,
  ) async {
    await _deleteRowsNotIn(
      txn,
      table: StatusMonitorTables.probeCatalogSuites,
      column: 'suite_id',
      values: catalog.suites.map((suite) => suite.suiteId),
    );
    await _deleteRowsNotIn(
      txn,
      table: StatusMonitorTables.probeCatalogProbes,
      column: 'probe_id',
      values: catalog.probes.map((probe) => probe.probeId),
    );
    await _deleteRowsNotIn(
      txn,
      table: StatusMonitorTables.probeScenarios,
      column: 'scenario_id',
      values: catalog.scenarios.map((scenario) => scenario.id),
    );

    final expectedScenarioItems = {
      for (final scenario in catalog.scenarios)
        for (final item in scenario.items)
          _scenarioItemKey(
            scenario.id,
            item.suiteId,
            item.probeId,
          ),
    };
    final existingItems = await txn.query(
      StatusMonitorTables.probeScenarioItems,
      columns: const ['scenario_id', 'suite_id', 'probe_id'],
    );
    for (final item in existingItems) {
      final key = _scenarioItemKey(
        item['scenario_id']?.toString() ?? '',
        item['suite_id']?.toString() ?? '',
        _nullableProbeId(item['probe_id']),
      );
      if (expectedScenarioItems.contains(key)) continue;
      final scenarioId = item['scenario_id']?.toString() ?? '';
      final suiteId = item['suite_id']?.toString() ?? '';
      final probeId = item['probe_id'];
      if (probeId == null) {
        await txn.delete(
          StatusMonitorTables.probeScenarioItems,
          where: 'scenario_id = ? AND suite_id = ? AND probe_id IS NULL',
          whereArgs: [scenarioId, suiteId],
        );
      } else {
        await txn.delete(
          StatusMonitorTables.probeScenarioItems,
          where: 'scenario_id = ? AND suite_id = ? AND probe_id = ?',
          whereArgs: [scenarioId, suiteId, probeId.toString()],
        );
      }
    }
  }

  Future<void> _deleteRowsNotIn(
    Transaction txn, {
    required String table,
    required String column,
    required Iterable<String> values,
  }) async {
    final ids = values.toSet().toList(growable: false);
    if (ids.isEmpty) {
      await txn.delete(table);
      return;
    }
    final placeholders = List.filled(ids.length, '?').join(', ');
    await txn.delete(
      table,
      where: '$column NOT IN ($placeholders)',
      whereArgs: ids,
    );
  }

  String _scenarioItemKey(
    String scenarioId,
    String suiteId,
    String? probeId,
  ) {
    return '$scenarioId\u001F$suiteId\u001F${probeId ?? ''}';
  }

  @override
  Future<StatusProbeCatalog> load() async {
    final database = await _database;
    final suiteRows = await database.query(
      StatusMonitorTables.probeCatalogSuites,
      orderBy: 'priority ASC',
    );
    final probeRows = await database.query(
      StatusMonitorTables.probeCatalogProbes,
      orderBy: 'suite_id ASC, priority ASC',
    );
    final scenarioRows = await database.query(
      StatusMonitorTables.probeScenarios,
      where: 'enabled = 1',
    );
    final scenarioItemRows = await database.query(
      StatusMonitorTables.probeScenarioItems,
      where: 'enabled = 1',
      orderBy: 'scenario_id ASC, order_index ASC',
    );
    return StatusProbeCatalog(
      suites: suiteRows.map(_suiteFromRow).toList(growable: false),
      probes: probeRows.map(_probeFromRow).toList(growable: false),
      scenarios: scenarioRows
          .map((row) => _scenarioFromRow(row, scenarioItemRows))
          .toList(growable: false),
    );
  }

  StatusProbeSuiteCatalogEntry _suiteFromRow(Map<String, Object?> row) {
    return StatusProbeSuiteCatalogEntry(
      suiteId: row['suite_id']?.toString() ?? '',
      kind: StatusProbeKind.values.firstWhere(
        (kind) => kind.name == row['kind']?.toString(),
        orElse: () => StatusProbeKind.common,
      ),
      display: StatusProbeDisplayDefinition(
        titleKey: row['title_key']?.toString() ?? '',
        descriptionKey: row['description_key']?.toString() ?? '',
        iconKey: row['icon_key']?.toString(),
      ),
      role: _role(row['role']),
      scoreScope: _scope(row['score_scope']),
      priority: _int(row['priority']),
      enabled: row['enabled'] == 1,
    );
  }

  StatusProbeCatalogEntry _probeFromRow(Map<String, Object?> row) {
    return StatusProbeCatalogEntry(
      probeId: row['probe_id']?.toString() ?? '',
      suiteId: row['suite_id']?.toString() ?? '',
      driverId: row['driver_id']?.toString() ?? '',
      display: StatusProbeDisplayDefinition(
        titleKey: row['title_key']?.toString() ?? '',
        descriptionKey: row['description_key']?.toString() ?? '',
        iconKey: row['icon_key']?.toString(),
        guideRoute: row['guide_route']?.toString(),
      ),
      role: _role(row['role']),
      scoreScope: _scope(row['score_scope']),
      required: row['required'] == 1,
      activationProbe: row['activation_probe'] == 1,
      priority: _int(row['priority']),
      enabled: row['enabled'] == 1,
    );
  }

  StatusProbeScenarioDefinition _scenarioFromRow(
    Map<String, Object?> row,
    List<Map<String, Object?>> items,
  ) {
    final id = row['scenario_id']?.toString() ?? '';
    return StatusProbeScenarioDefinition(
      id: id,
      titleKey: row['title_key']?.toString() ?? '',
      descriptionKey: row['description_key']?.toString() ?? '',
      items: items
          .where((item) => item['scenario_id']?.toString() == id)
          .map(
            (item) => StatusProbeScenarioItem(
              suiteId: item['suite_id']?.toString() ?? '',
              probeId: _nullableProbeId(item['probe_id']),
              sectionId: _nullableText(item['section_id']),
              orderIndex: _int(item['order_index']),
              enabled: item['enabled'] == 1,
              weight: _double(item['weight'], fallback: 1),
              scoreScope: _nullableScope(item['score_scope']),
              hardGate: item['hard_gate'] == 1,
              activationProbe: item['activation_probe'] == 1,
              scoreCap: _nullableInt(item['score_cap']),
            ),
          )
          .toList(growable: false),
    );
  }

  String? _nullableProbeId(Object? value) {
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }

  String? _nullableText(Object? value) {
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }

  int _int(Object? value) {
    return value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
  }

  int? _nullableInt(Object? value) {
    final text = value?.toString();
    if (text == null || text.isEmpty) return null;
    return int.tryParse(text);
  }

  double _double(Object? value, {required double fallback}) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  StatusProbePathRole _role(Object? value) {
    return StatusProbePathRole.values.firstWhere(
      (role) => role.name == value?.toString(),
      orElse: () => StatusProbePathRole.core,
    );
  }

  StatusProbeScoreScope _scope(Object? value) {
    return StatusProbeScoreScope.values.firstWhere(
      (scope) => scope.name == value?.toString(),
      orElse: () => StatusProbeScoreScope.included,
    );
  }

  StatusProbeScoreScope? _nullableScope(Object? value) {
    final text = value?.toString();
    if (text == null || text.isEmpty) return null;
    return StatusProbeScoreScope.values.firstWhere(
      (scope) => scope.name == text,
      orElse: () => StatusProbeScoreScope.included,
    );
  }
}
