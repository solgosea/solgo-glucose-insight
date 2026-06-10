import 'dart:async';
import 'dart:io';

import 'package:flutter_background_service/flutter_background_service.dart';

import '../../application/background_runtime/background_runtime_decision.dart';
import '../../application/sync_strategy/data_source_sync_strategy_coordinator.dart';
import '../../alerting/domain/actuator/alert_actuator_command.dart';
import '../../alerting/domain/actuator/alert_actuator_command_type.dart';
import '../../domain/entities/app_settings.dart';
import 'background_service_commands.dart';
import 'background_service_entrypoint.dart';
import 'background_service_notification_builder.dart';

class FlutterBackgroundServiceAdapter {
  final FlutterBackgroundService _service;
  final BackgroundServiceNotificationBuilder _notificationBuilder;
  final DataSourceSyncStrategyCoordinator _strategyCoordinator;
  StreamSubscription<Map<String, dynamic>?>? _syncStatusSubscription;
  bool _configured = false;

  FlutterBackgroundServiceAdapter({
    FlutterBackgroundService? service,
    BackgroundServiceNotificationBuilder? notificationBuilder,
    DataSourceSyncStrategyCoordinator? strategyCoordinator,
  }) : _service = service ?? FlutterBackgroundService(),
       _notificationBuilder =
           notificationBuilder ?? const BackgroundServiceNotificationBuilder(),
       _strategyCoordinator =
           strategyCoordinator ?? const DataSourceSyncStrategyCoordinator();

  Stream<Map<String, dynamic>?> get syncStatusEvents =>
      _service.on(BackgroundServiceCommands.syncStatus);

  Future<void> initialize() async {
    if (!Platform.isAndroid) return;
    if (_configured) return;

    final initial = _notificationBuilder.initial;
    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: smartXdripBackgroundServiceOnStart,
        autoStart: false,
        autoStartOnBoot: true,
        isForegroundMode: true,
        initialNotificationTitle: initial.title,
        initialNotificationContent: initial.content,
        foregroundServiceNotificationId: 17580,
        foregroundServiceTypes: const [
          AndroidForegroundType.dataSync,
          AndroidForegroundType.mediaPlayback,
        ],
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: smartXdripBackgroundServiceOnStart,
        onBackground: smartXdripIosBackground,
      ),
    );
    _configured = true;
  }

  Future<void> syncWithSettings(
    AppSettings settings, {
    bool forceStart = false,
  }) async {
    if (!Platform.isAndroid) return;
    await initialize();
    if (!forceStart && !_strategyCoordinator.hasEnabledStrategy(settings)) {
      await stop();
      return;
    }

    if (!await _service.isRunning()) {
      await _service.startService();
      return;
    }
    _service.invoke(BackgroundServiceCommands.settingsChanged);
  }

  Future<void> syncWithDecision(
    AppSettings settings,
    BackgroundRuntimeDecision decision,
  ) {
    return syncWithSettings(settings, forceStart: decision.shouldRun);
  }

  Future<void> runOnce() async {
    if (!Platform.isAndroid) return;
    if (!await _service.isRunning()) return;
    _service.invoke(BackgroundServiceCommands.runOnce);
  }

  Future<void> dispatchAlertActuatorCommand(
    AlertActuatorCommand command,
  ) async {
    if (!Platform.isAndroid) return;
    if (!await _service.isRunning()) return;
    _service.invoke(BackgroundServiceCommands.alertActuatorCommand, {
      'commandType': command.type.code,
      'eventId': command.target.eventId,
      'targetId': command.target.targetId,
      'type': command.target.type,
    });
  }

  Future<void> stopAlertTarget({
    required String targetId,
    required String type,
  }) async {
    if (!Platform.isAndroid) return;
    if (!await _service.isRunning()) return;
    _service.invoke(BackgroundServiceCommands.alertActuatorCommand, {
      'commandType': AlertActuatorCommandType.stopTarget.code,
      'targetId': targetId,
      'type': type,
    });
  }

  Future<void> stop() async {
    if (!Platform.isAndroid) return;
    if (await _service.isRunning()) {
      _service.invoke(BackgroundServiceCommands.stop);
    }
  }

  StreamSubscription<Map<String, dynamic>?> listenSyncStatus(
    void Function(Map<String, dynamic>? event) listener,
  ) {
    _syncStatusSubscription?.cancel();
    _syncStatusSubscription = syncStatusEvents.listen(listener);
    return _syncStatusSubscription!;
  }

  Future<void> dispose() async {
    await _syncStatusSubscription?.cancel();
    _syncStatusSubscription = null;
  }
}
