import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/dedupe/alert_source_priority.dart';
import 'package:smart_xdrip/alerting/application/queue/alert_queue_enqueue_service.dart';
import 'package:smart_xdrip/alerting/application/center/alert_message_handler_registry.dart';
import 'package:smart_xdrip/alerting/application/queue/alert_queue_consumer.dart';
import 'package:smart_xdrip/alerting/data/sqlite/sqlite_alert_queue_repository.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_message.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_priority.dart';

import '../_support/test_database.dart';

void main() {
  test('same dedupe key keeps Remote message over Local datasource', () async {
    final database = await TestDatabase.createWithAlerting();
    addTearDown(database.close);
    final repository = SqliteAlertQueueRepository(
      databaseProvider: () => database.db,
    );
    final consumer = AlertQueueConsumer(
      repository: repository,
      registry: AlertMessageHandlerRegistry(),
    );
    final service = AlertQueueEnqueueService(
      repository: repository,
      consumer: consumer,
    );
    final now = DateTime(2026, 6, 9, 8);
    const dedupeKey = 'nightscout:https://demo.fly.dev:urgentLow:1';

    await service.enqueue(_message(
      id: 'local',
      dedupeKey: dedupeKey,
      sourcePriority: AlertSourcePriority.localDatasource,
      now: now,
    ));
    await service.enqueue(_message(
      id: 'remote',
      dedupeKey: dedupeKey,
      sourcePriority: AlertSourcePriority.remote,
      now: now,
    ));

    final stored = await repository.findByDedupeKey(dedupeKey);
    expect(stored?.id, 'remote');
    expect(stored?.sourcePriority, AlertSourcePriority.remote);
  });
}

AlertQueueMessage _message({
  required String id,
  required String dedupeKey,
  required int sourcePriority,
  required DateTime now,
}) {
  return AlertQueueMessage(
    id: id,
    dedupeKey: dedupeKey,
    messageType: 'test',
    source: id,
    alertType: 'urgentLow',
    sourcePriority: sourcePriority,
    priority: AlertQueuePriority.critical,
    payload: const {},
    availableAt: now,
    createdAt: now,
    updatedAt: now,
  );
}
