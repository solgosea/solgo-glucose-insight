import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/center/alert_message_handler_registry.dart';
import 'package:smart_xdrip/alerting/application/ingress/alert_ingress.dart';
import 'package:smart_xdrip/alerting/application/queue/alert_queue_consumer.dart';
import 'package:smart_xdrip/alerting/data/sqlite/sqlite_alert_queue_repository.dart';
import 'package:smart_xdrip/alerting/domain/handler/alert_message_handler.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_message.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_priority.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_processing_result.dart';
import 'package:smart_xdrip/alerting/domain/queue/alert_queue_source.dart';

import '../_support/test_database.dart';

void main() {
  test('alert queue accepts plugin handlers without feature dependencies',
      () async {
    final database = await TestDatabase.createWithAlerting();
    final queueRepository = SqliteAlertQueueRepository(
      databaseProvider: () => database.db,
    );
    final handler = _FakePluginAlertHandler();
    final registry = AlertMessageHandlerRegistry()..register(handler);
    final consumer = AlertQueueConsumer(
      repository: queueRepository,
      registry: registry,
    );
    final ingress = AlertIngress(
      repository: queueRepository,
      consumer: consumer,
      clock: () => DateTime(2026, 6, 9, 8),
    );

    await ingress.enqueue(
      messageType: _FakePluginAlertHandler.messageType,
      source: AlertQueueSource.system,
      targetPluginId: 'fake.plugin',
      targetId: 'card-1',
      subjectId: 'subject-1',
      alertEventId: 'fake-alert-1',
      alertType: 'summaryReady',
      priority: AlertQueuePriority.high,
      payload: {'value': 42},
      dedupeKey: 'fake.plugin:summaryReady:fake-alert-1',
    );
    for (var i = 0; i < 20 && handler.handledPayloads.isEmpty; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await consumer.drain();
    }

    expect(handler.handledPayloads, [
      {'value': 42},
    ]);
    expect(await queueRepository.pendingCount(), 0);

    await consumer.waitForIdle();
    await database.close();
  });
}

class _FakePluginAlertHandler implements AlertMessageHandler {
  static const messageType = 'fake.plugin.alert';

  final handledPayloads = <Map<String, Object?>>[];

  @override
  String get id => 'fake-plugin-alert-handler';

  @override
  bool supports(AlertQueueMessage message) {
    return message.messageType == messageType &&
        message.targetPluginId == 'fake.plugin';
  }

  @override
  Future<AlertQueueProcessingResult> handle(AlertQueueMessage message) async {
    handledPayloads.add(message.payload);
    return const AlertQueueProcessingResult.processed();
  }
}
