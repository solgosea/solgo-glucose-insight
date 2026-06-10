import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/alerting_tables.dart';

import '../_support/test_database.dart';

void main() {
  test('creates first-version alerting tables', () async {
    final database = await TestDatabase.createWithAlerting();
    addTearDown(database.close);

    final db = await database.db;
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    final names = rows.map((row) => row['name']).toSet();

    expect(names, contains(AlertingTables.events));
    expect(names, contains(AlertingTables.queueMessages));
    expect(names, contains(AlertingTables.strategyConfigs));
    expect(names, contains(AlertingTables.deliveryPlans));
    expect(names, contains(AlertingTables.deliveryLogs));
    expect(names, contains(AlertingTables.actionLogs));
    expect(names, contains(AlertingTables.snoozeRules));
    expect(names, contains(AlertingTables.resources));
    expect(names, contains(AlertingTables.ruleSets));
    expect(names, contains(AlertingTables.rules));
  });
}
