import 'dart:ui';

import '../data/local/glucose_database.dart';
import 'application/actuator/alert_actuator_command_bus.dart';
import 'application/actuator/alert_actuator_command_queue.dart';
import 'application/actuator/alert_actuator_dispatcher.dart';
import 'application/action/alert_action_orchestrator.dart';
import 'application/action/alert_action_service.dart';
import 'application/action/alert_notification_action_bridge.dart';
import 'application/action/alert_notification_action_dispatcher.dart';
import 'application/actuator/notification_alert_actuator.dart';
import 'application/actuator/sound_alert_actuator.dart';
import 'application/actuator/vibration_alert_actuator.dart';
import 'application/center/alert_message_handler_registry.dart';
import 'application/delivery/alert_delivery_pipeline.dart';
import 'application/delivery/alert_delivery_gate.dart';
import 'application/delivery/alert_strategy_registry.dart';
import 'application/event/alert_event_factory.dart';
import 'application/event/alert_event_queue_message_handler.dart';
import 'application/ingress/alert_ingress.dart';
import 'application/ingress/alerting_center.dart';
import 'application/orchestration/alert_orchestrator.dart';
import 'application/policy/alert_policy_engine.dart';
import 'application/queue/alert_queue_consumer.dart';
import 'application/queue/alert_queue_enqueue_service.dart';
import 'application/rule/alert_rule_provider.dart';
import 'application/source/alert_ingress_source_sink.dart';
import 'application/source/alert_source_registry.dart';
import 'application/text/alert_text_renderer_registry.dart';
import 'application/text/core_alert_text_renderer_registrar.dart';
import 'data/sqlite/sqlite_alert_delivery_log_repository.dart';
import 'data/sqlite/sqlite_alert_event_repository.dart';
import 'data/sqlite/sqlite_alert_queue_repository.dart';
import 'data/sqlite/sqlite_alert_rule_repository.dart';
import 'data/sqlite/sqlite_alert_strategy_config_repository.dart';
import 'data/sqlite/sqlite_alert_action_repository.dart';
import 'infrastructure/background/alert_actuator_background_service_forwarder.dart';
import 'infrastructure/local_notifications/alert_notification_action_router.dart';
import 'infrastructure/local_notifications/alert_notification_background_entrypoint.dart';
import 'infrastructure/local_notifications/flutter_local_notification_gateway.dart';
import 'presentation/overlays/alert_overlay_signal_bus.dart';
import 'strategies/in_app/in_app_alert_strategy.dart';
import 'strategies/local_notification/local_notification_alert_strategy.dart';
import 'strategies/sound/sound_alert_strategy.dart';
import 'strategies/vibration/vibration_alert_strategy.dart';
import 'suppression/alert_core_snooze_suppression_policy.dart';
import 'suppression/alert_suppression_policy_registry.dart';

class AlertingRuntimeFactory {
  final GlucoseDatabase database;
  final AlertOverlaySignalBus overlaySignalBus;
  final AlertSuppressionPolicyRegistry suppressionRegistry;
  final Locale? Function()? localeProvider;
  AlertActuatorCommandBus? _commandBus;
  AlertOrchestrator? _orchestrator;
  AlertActionService? _actionService;
  AlertActionOrchestrator? _actionOrchestrator;
  AlertMessageHandlerRegistry? _messageHandlerRegistry;
  AlertQueueConsumer? _queueConsumer;
  AlertQueueEnqueueService? _queueEnqueueService;
  AlertIngress? _alertIngress;
  AlertRuleProvider? _alertRuleProvider;
  AlertSourceRegistry? _sourceRegistry;
  AlertIngressSourceSink? _sourceSink;
  AlertTextRendererRegistry? _textRendererRegistry;
  AlertEventFactory? _eventFactory;
  FlutterLocalNotificationGateway? _notificationGateway;
  AlertNotificationActionBridge? _notificationActionBridge;
  AlertNotificationActionDispatcher? _notificationActionDispatcher;
  AlertNotificationActionRouter? _notificationActionRouter;
  AlertActuatorBackgroundServiceForwarder? _backgroundServiceForwarder;
  bool _directEventHandlerRegistered = false;
  bool _coreTextRenderersRegistered = false;

  AlertingRuntimeFactory({
    required this.database,
    required this.overlaySignalBus,
    AlertSuppressionPolicyRegistry? suppressionRegistry,
    this.localeProvider,
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
        databaseProvider: () => database.db);
  }

  SqliteAlertActionRepository actionRepository() {
    return SqliteAlertActionRepository(databaseProvider: () => database.db);
  }

  AlertActionService actionService() {
    return _actionService ??= AlertActionService(
      eventRepository: eventRepository(),
      actionRepository: actionRepository(),
    );
  }

  SqliteAlertQueueRepository queueRepository() {
    return SqliteAlertQueueRepository(databaseProvider: () => database.db);
  }

  SqliteAlertRuleRepository ruleRepository() {
    return SqliteAlertRuleRepository(databaseProvider: () => database.db);
  }

  AlertRuleProvider ruleProvider() {
    return _alertRuleProvider ??= AlertRuleProvider(
      repository: ruleRepository(),
    );
  }

  AlertTextRendererRegistry textRendererRegistry() {
    final registry = _textRendererRegistry ??= AlertTextRendererRegistry();
    if (!_coreTextRenderersRegistered) {
      const CoreAlertTextRendererRegistrar().register(registry);
      _coreTextRenderersRegistered = true;
    }
    return registry;
  }

  AlertEventFactory eventFactory() {
    return _eventFactory ??= AlertEventFactory(
      textRegistry: textRendererRegistry(),
    );
  }

  AlertMessageHandlerRegistry messageHandlerRegistry() {
    final registry = _messageHandlerRegistry ??= AlertMessageHandlerRegistry();
    _registerDirectEventHandler(registry);
    return registry;
  }

  void _registerDirectEventHandler(AlertMessageHandlerRegistry registry) {
    if (_directEventHandlerRegistered) return;
    registry.register(AlertEventQueueMessageHandler(center: center()));
    _directEventHandlerRegistered = true;
  }

  AlertQueueConsumer queueConsumer() {
    return _queueConsumer ??= AlertQueueConsumer(
      repository: queueRepository(),
      registry: messageHandlerRegistry(),
    );
  }

  AlertQueueEnqueueService queueEnqueueService() {
    return _queueEnqueueService ??= AlertQueueEnqueueService(
      repository: queueRepository(),
      consumer: queueConsumer(),
    );
  }

  AlertIngress alertIngress() {
    return _alertIngress ??= AlertIngress(
      enqueueService: queueEnqueueService(),
    );
  }

  AlertSourceRegistry sourceRegistry() {
    return _sourceRegistry ??= AlertSourceRegistry();
  }

  AlertIngressSourceSink sourceSink() {
    return _sourceSink ??= AlertIngressSourceSink(
      ingress: alertIngress(),
    );
  }

  AlertActuatorCommandBus commandBus() {
    return _commandBus ??= AlertActuatorCommandBus(
      queue: AlertActuatorCommandQueue(),
      backgroundForwarder: backgroundServiceForwarder().call,
      dispatcher: AlertActuatorDispatcher(
        actuators: [
          SoundAlertActuator(),
          const VibrationAlertActuator(),
          NotificationAlertActuator(
            gateway: notificationGateway(),
          ),
        ],
      ),
    );
  }

  AlertActuatorBackgroundServiceForwarder backgroundServiceForwarder() {
    return _backgroundServiceForwarder ??=
        AlertActuatorBackgroundServiceForwarder();
  }

  AlertOrchestrator orchestrator() {
    return _orchestrator ??= AlertOrchestrator(commandBus: commandBus());
  }

  AlertActionOrchestrator actionOrchestrator() {
    return _actionOrchestrator ??= AlertActionOrchestrator(
      actionService: actionService(),
      actuatorOrchestrator: orchestrator(),
    );
  }

  FlutterLocalNotificationGateway notificationGateway() {
    return _notificationGateway ??= FlutterLocalNotificationGateway(
      localeProvider: localeProvider,
      backgroundActionHandler: alertNotificationBackgroundEntrypoint,
    );
  }

  AlertNotificationActionBridge notificationActionBridge() {
    return _notificationActionBridge ??= AlertNotificationActionBridge(
      eventRepository: eventRepository(),
      actionOrchestrator: actionOrchestrator(),
    );
  }

  AlertNotificationActionDispatcher notificationActionDispatcher() {
    return _notificationActionDispatcher ??= AlertNotificationActionDispatcher(
      bridge: notificationActionBridge(),
    );
  }

  AlertNotificationActionRouter notificationActionRouter() {
    return _notificationActionRouter ??= AlertNotificationActionRouter(
      dispatcher: notificationActionDispatcher(),
    );
  }

  Future<void> configureNotificationActions() async {
    final gateway = notificationGateway();
    gateway.bindActionRouter(notificationActionRouter());
    await gateway.initialize();
  }

  AlertingCenter center() {
    _ensureCoreSuppressionPolicies();
    final bus = commandBus();
    final registry = AlertStrategyRegistry([
      InAppAlertStrategy(signalBus: overlaySignalBus),
      LocalNotificationAlertStrategy(
        gateway: notificationGateway(),
        commandBus: bus,
      ),
      SoundAlertStrategy(commandBus: bus),
      VibrationAlertStrategy(commandBus: bus),
    ]);
    return AlertingCenter(
      eventRepository: eventRepository(),
      configRepository: configRepository(),
      policyEngine: const AlertPolicyEngine(),
      deliveryGate: AlertDeliveryGate(
        suppressionRegistry: suppressionRegistry,
      ),
      deliveryPipeline: AlertDeliveryPipeline(
        registry: registry,
        logRepository: deliveryLogRepository(),
      ),
    );
  }

  void _ensureCoreSuppressionPolicies() {
    suppressionRegistry.register(
      AlertCoreSnoozeSuppressionPolicy(repository: actionRepository()),
    );
  }
}
