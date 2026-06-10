import '../../../data/local/glucose_database.dart';
import '../../application/actuator/alert_actuator_command_bus.dart';
import '../../application/actuator/alert_actuator_command_queue.dart';
import '../../application/actuator/alert_actuator_dispatcher.dart';
import '../../application/actuator/notification_alert_actuator.dart';
import '../../application/actuator/sound_alert_actuator.dart';
import '../../application/actuator/vibration_alert_actuator.dart';
import '../../application/center/alert_message_handler_registry.dart';
import '../../application/delivery/alert_delivery_gate.dart';
import '../../application/delivery/alert_delivery_pipeline.dart';
import '../../application/delivery/alert_strategy_registry.dart';
import '../../application/ingress/alert_ingress.dart';
import '../../application/ingress/alerting_center.dart';
import '../../application/orchestration/alert_orchestrator.dart';
import '../../application/policy/alert_policy_engine.dart';
import '../../application/queue/alert_queue_consumer.dart';
import '../../data/sqlite/sqlite_alert_delivery_log_repository.dart';
import '../../data/sqlite/sqlite_alert_event_repository.dart';
import '../../data/sqlite/sqlite_alert_queue_repository.dart';
import '../../data/sqlite/sqlite_alert_strategy_config_repository.dart';
import '../local_notifications/flutter_local_notification_gateway.dart';
import '../../strategies/local_notification/local_notification_alert_strategy.dart';
import '../../strategies/sound/sound_alert_strategy.dart';
import '../../strategies/vibration/vibration_alert_strategy.dart';
import '../../suppression/alert_suppression_policy_registry.dart';

class BackgroundAlertingRuntimeFactory {
  final GlucoseDatabase database;
  final AlertSuppressionPolicyRegistry suppressionRegistry;
  AlertActuatorCommandBus? _commandBus;
  AlertOrchestrator? _orchestrator;
  AlertMessageHandlerRegistry? _messageHandlerRegistry;
  AlertQueueConsumer? _queueConsumer;
  AlertIngress? _alertIngress;

  BackgroundAlertingRuntimeFactory({
    required this.database,
    AlertSuppressionPolicyRegistry? suppressionRegistry,
  }) : suppressionRegistry =
           suppressionRegistry ?? AlertSuppressionPolicyRegistry();

  SqliteAlertEventRepository eventRepository() {
    return SqliteAlertEventRepository(databaseProvider: () => database.db);
  }

  SqliteAlertStrategyConfigRepository configRepository() {
    return SqliteAlertStrategyConfigRepository(
      databaseProvider: () => database.db,
    );
  }

  SqliteAlertDeliveryLogRepository deliveryLogRepository() {
    return SqliteAlertDeliveryLogRepository(
      databaseProvider: () => database.db,
    );
  }

  SqliteAlertQueueRepository queueRepository() {
    return SqliteAlertQueueRepository(databaseProvider: () => database.db);
  }

  AlertMessageHandlerRegistry messageHandlerRegistry() {
    return _messageHandlerRegistry ??= AlertMessageHandlerRegistry();
  }

  AlertQueueConsumer queueConsumer() {
    return _queueConsumer ??= AlertQueueConsumer(
      repository: queueRepository(),
      registry: messageHandlerRegistry(),
    );
  }

  AlertIngress alertIngress() {
    return _alertIngress ??= AlertIngress(
      repository: queueRepository(),
      consumer: queueConsumer(),
    );
  }

  AlertActuatorCommandBus commandBus() {
    return _commandBus ??= AlertActuatorCommandBus(
      queue: AlertActuatorCommandQueue(),
      dispatcher: AlertActuatorDispatcher(
        actuators: [
          SoundAlertActuator(),
          const VibrationAlertActuator(),
          NotificationAlertActuator(gateway: FlutterLocalNotificationGateway()),
        ],
      ),
    );
  }

  AlertOrchestrator orchestrator() {
    return _orchestrator ??= AlertOrchestrator(commandBus: commandBus());
  }

  AlertingCenter center() {
    final bus = commandBus();
    final registry = AlertStrategyRegistry([
      LocalNotificationAlertStrategy(
        gateway: FlutterLocalNotificationGateway(),
        commandBus: bus,
      ),
      SoundAlertStrategy(commandBus: bus),
      VibrationAlertStrategy(commandBus: bus),
    ]);
    return AlertingCenter(
      eventRepository: eventRepository(),
      configRepository: configRepository(),
      policyEngine: const AlertPolicyEngine(),
      deliveryGate: AlertDeliveryGate(suppressionRegistry: suppressionRegistry),
      deliveryPipeline: AlertDeliveryPipeline(
        registry: registry,
        logRepository: deliveryLogRepository(),
      ),
    );
  }
}
