import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/action/alert_action_orchestrator.dart';
import 'package:smart_xdrip/alerting/application/action/alert_action_service.dart';
import 'package:smart_xdrip/alerting/application/action/alert_notification_action_bridge.dart';
import 'package:smart_xdrip/alerting/application/actuator/alert_actuator.dart';
import 'package:smart_xdrip/alerting/application/actuator/alert_actuator_command_bus.dart';
import 'package:smart_xdrip/alerting/application/actuator/alert_actuator_command_queue.dart';
import 'package:smart_xdrip/alerting/application/actuator/alert_actuator_dispatcher.dart';
import 'package:smart_xdrip/alerting/application/orchestration/alert_orchestrator.dart';
import 'package:smart_xdrip/alerting/domain/action/alert_action.dart';
import 'package:smart_xdrip/alerting/domain/actuator/alert_actuator_command.dart';
import 'package:smart_xdrip/alerting/domain/actuator/alert_actuator_command_type.dart';
import 'package:smart_xdrip/alerting/domain/actuator/alert_actuator_result.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_source.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_state.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_level.dart';
import 'package:smart_xdrip/alerting/domain/repository/alert_action_repository.dart';
import 'package:smart_xdrip/alerting/domain/repository/alert_event_repository.dart';
import 'package:smart_xdrip/alerting/infrastructure/local_notifications/alert_notification_action_ids.dart';
import 'package:smart_xdrip/alerting/infrastructure/local_notifications/alert_notification_payload_codec.dart';

void main() {
  test('notification snooze action uses the shared alert action pipeline',
      () async {
    final events = _MemoryAlertEventRepository();
    final actions = _MemoryAlertActionRepository();
    final actuator = _RecordingActuator();
    final bus = AlertActuatorCommandBus(
      queue: AlertActuatorCommandQueue(),
      dispatcher: AlertActuatorDispatcher(actuators: [actuator]),
    );
    final bridge = AlertNotificationActionBridge(
      eventRepository: events,
      actionOrchestrator: AlertActionOrchestrator(
        actionService: AlertActionService(
          eventRepository: events,
          actionRepository: actions,
        ),
        actuatorOrchestrator: AlertOrchestrator(commandBus: bus),
      ),
    );
    await events.upsert(_event());

    final result = await bridge.handle(
      actionId: AlertNotificationActionIds.snooze,
      payload: const AlertNotificationPayloadCodec().encode(
        alertEventId: 'alert-1',
      ),
    );

    expect(result.success, isTrue);
    expect((await events.byId('alert-1'))?.state, AlertEventState.snoozed);
    expect(actions.actions.single.action, AlertAction.snooze);
    expect(actions.actions.single.actor, 'system_notification');
    expect(actions.snoozes.single.targetId, 'child-1');
    expect(actions.snoozes.single.alertType, 'urgentLow');
    expect(actuator.commands.map((command) => command.type), [
      AlertActuatorCommandType.stopEvent,
      AlertActuatorCommandType.stopTarget,
    ]);
    expect(actuator.commands.first.target.eventId, 'alert-1');
    expect(actuator.commands.last.target.targetId, 'child-1');
    expect(actuator.commands.last.target.type, 'urgentLow');
  });

  test('notification dismiss action is event scoped', () async {
    final events = _MemoryAlertEventRepository();
    final actions = _MemoryAlertActionRepository();
    final actuator = _RecordingActuator();
    final bus = AlertActuatorCommandBus(
      queue: AlertActuatorCommandQueue(),
      dispatcher: AlertActuatorDispatcher(actuators: [actuator]),
    );
    final bridge = AlertNotificationActionBridge(
      eventRepository: events,
      actionOrchestrator: AlertActionOrchestrator(
        actionService: AlertActionService(
          eventRepository: events,
          actionRepository: actions,
        ),
        actuatorOrchestrator: AlertOrchestrator(commandBus: bus),
      ),
    );
    await events.upsert(_event());

    final result = await bridge.handle(
      actionId: AlertNotificationActionIds.dismiss,
      payload: const AlertNotificationPayloadCodec().encode(
        alertEventId: 'alert-1',
      ),
    );

    expect(result.success, isTrue);
    expect((await events.byId('alert-1'))?.state, AlertEventState.dismissed);
    expect(actions.actions.single.action, AlertAction.dismiss);
    expect(actions.snoozes, isEmpty);
    expect(actuator.commands.map((command) => command.type), [
      AlertActuatorCommandType.stopEvent,
      AlertActuatorCommandType.stopTarget,
    ]);
  });
}

AlertEvent _event() {
  final now = DateTime(2026, 6, 11, 10);
  return AlertEvent(
    id: 'alert-1',
    source: const AlertEventSource('remote.im'),
    sourceEventId: 'evt-1',
    category: AlertCategory.glucoseUrgentLow,
    level: AlertLevel.critical,
    state: AlertEventState.received,
    title: 'Urgent Low',
    body: '3.2 mmol/L',
    payload: const {
      'personId': 'child-1',
      'type': 'urgentLow',
    },
    occurredAt: now,
    receivedAt: now,
    updatedAt: now,
  );
}

class _MemoryAlertEventRepository implements AlertEventRepository {
  final Map<String, AlertEvent> events = {};

  @override
  Future<void> upsert(AlertEvent event) async {
    events[event.id] = event;
  }

  @override
  Future<AlertEvent?> byId(String id) async {
    return events[id];
  }

  @override
  Future<List<AlertEvent>> latest({int limit = 50}) async {
    return events.values.take(limit).toList(growable: false);
  }

  @override
  Future<void> updateState(String id, AlertEventState state) async {
    final event = events[id];
    if (event == null) return;
    events[id] = event.copyWith(state: state, updatedAt: DateTime.now());
  }
}

class _MemoryAlertActionRepository implements AlertActionRepository {
  final List<_ActionRecord> actions = [];
  final List<_SnoozeRecord> snoozes = [];

  @override
  Future<void> insertAction({
    required String alertEventId,
    required AlertAction action,
    required String actor,
    String? note,
  }) async {
    actions.add(_ActionRecord(
      alertEventId: alertEventId,
      action: action,
      actor: actor,
    ));
  }

  @override
  Future<void> insertSnooze({
    required String alertEventId,
    required DateTime snoozedUntil,
    String? targetId,
    String? alertType,
    String? source,
    String? category,
    String? level,
    String? reason,
  }) async {
    snoozes.add(_SnoozeRecord(
      alertEventId: alertEventId,
      targetId: targetId,
      alertType: alertType,
    ));
  }

  @override
  Future<DateTime?> activeSnoozeUntil({
    required String targetId,
    required String alertType,
    required DateTime now,
  }) async {
    return null;
  }
}

class _ActionRecord {
  final String alertEventId;
  final AlertAction action;
  final String actor;

  const _ActionRecord({
    required this.alertEventId,
    required this.action,
    required this.actor,
  });
}

class _SnoozeRecord {
  final String alertEventId;
  final String? targetId;
  final String? alertType;

  const _SnoozeRecord({
    required this.alertEventId,
    this.targetId,
    this.alertType,
  });
}

class _RecordingActuator implements AlertActuator {
  final List<AlertActuatorCommand> commands = [];

  @override
  bool supports(AlertActuatorCommand command) => true;

  @override
  Future<AlertActuatorResult> execute(AlertActuatorCommand command) async {
    commands.add(command);
    return const AlertActuatorResult.success();
  }
}
