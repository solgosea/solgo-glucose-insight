import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/center/alert_message_handler_registry.dart';
import 'package:smart_xdrip/alerting/application/queue/alert_queue_consumer.dart';
import 'package:smart_xdrip/alerting/data/sqlite/sqlite_alert_queue_repository.dart';
import 'package:smart_xdrip/alerting/domain/handler/alert_message_handler.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_message.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_processing_result.dart';

import '../_support/test_database.dart';

void main() {
  test('deduplicates and drains alert queue messages', () async {
    final database = await TestDatabase.createWithAlerting();
    addTearDown(database.close);
    final repository = SqliteAlertQueueRepository(
      databaseProvider: () => database.db,
    );
    final registry = AlertMessageHandlerRegistry();
    final handler = _CountingHandler('test.message');
    registry.register(handler);
    final consumer = AlertQueueConsumer(
      repository: repository,
      registry: registry,
    );
    final now = DateTime(2020, 1, 1);

    await repository.enqueue(
      AlertQueueMessage(
        id: 'queue-1',
        messageType: 'test.message',
        dedupeKey: 'same-message',
        source: 'test',
        payload: const {'value': 1},
        availableAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await repository.enqueue(
      AlertQueueMessage(
        id: 'queue-2',
        messageType: 'test.message',
        dedupeKey: 'same-message',
        source: 'test',
        payload: const {'value': 1},
        availableAt: now,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await consumer.drain();

    expect(handler.handled, hasLength(1));
    expect(await repository.pendingCount(), 0);
  });
}

class _CountingHandler implements AlertMessageHandler {
  final String supportedType;
  final List<AlertQueueMessage> handled = [];

  _CountingHandler(this.supportedType);

  @override
  String get id => 'counting';

  @override
  bool supports(AlertQueueMessage message) {
    return message.messageType == supportedType;
  }

  @override
  Future<AlertQueueProcessingResult> handle(AlertQueueMessage message) async {
    handled.add(message);
    return const AlertQueueProcessingResult.processed();
  }
}
