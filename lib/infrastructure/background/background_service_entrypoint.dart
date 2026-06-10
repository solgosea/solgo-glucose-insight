import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import '../../application/background_sync/background_sync_coordinator_factory.dart';
import '../../application/background_sync/background_sync_post_task_registry.dart';
import '../../application/background_capability/background_capability_install_context.dart';
import '../../application/sync_target/glucose_sync_target_registry.dart';
import '../../application/sync_target/providers/self_data_source_sync_target_provider.dart';
import '../../alerting/application/sound/alert_sound_session_manager.dart';
import '../../alerting/domain/actuator/alert_actuator_command_type.dart';
import '../../data/local/glucose_database.dart';
import '../../plugins/background_capability_catalog.dart';
import 'background_service_commands.dart';
import 'background_service_notification_builder.dart';

@pragma('vm:entry-point')
Future<bool> smartXdripIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void smartXdripBackgroundServiceOnStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  const notificationBuilder = BackgroundServiceNotificationBuilder();
  final database = GlucoseDatabase();
  final syncTargetRegistry = GlucoseSyncTargetRegistry(
    providers: const [SelfDataSourceSyncTargetProvider()],
  );
  final postTaskRegistry = BackgroundSyncPostTaskRegistry();
  builtInBackgroundCapabilityCatalog.installAll(
    BackgroundCapabilityInstallContext(
      database: database,
      syncTargetRegistry: syncTargetRegistry,
      postTaskRegistry: postTaskRegistry,
    ),
  );
  final coordinator =
      BackgroundSyncCoordinatorFactory(
        database: database,
        syncTargetRegistry: syncTargetRegistry,
        postTaskRegistry: postTaskRegistry,
        xdripSupported: Platform.isAndroid,
      ).create();

  Timer? timer;
  var running = false;
  late void Function(Duration interval) scheduleNext;

  Future<void> runOnce(String reason) async {
    if (running) return;
    running = true;
    try {
      if (service is AndroidServiceInstance) {
        await service.setAsForegroundService();
        await service.setForegroundNotificationInfo(
          title: notificationBuilder.initial.title,
          content:
              reason == 'start'
                  ? notificationBuilder.initial.content
                  : 'Sync requested by $reason...',
        );
      }

      final snapshot = await coordinator.runOnce();
      final notification = notificationBuilder.fromSnapshot(snapshot);
      if (service is AndroidServiceInstance) {
        await service.setForegroundNotificationInfo(
          title: notification.title,
          content: notification.content,
        );
      }
      service.invoke(BackgroundServiceCommands.syncStatus, snapshot.toMap());
      scheduleNext(snapshot.nextSyncInterval);
    } catch (error) {
      if (service is AndroidServiceInstance) {
        await service.setForegroundNotificationInfo(
          title: 'SmartXDrip sync',
          content: 'Sync failed. Will retry automatically.',
        );
      }
      service.invoke(BackgroundServiceCommands.syncStatus, {
        'status': 'failed',
        'source': 'none',
        'checkedAt': DateTime.now().toIso8601String(),
        'message': error.toString(),
      });
      scheduleNext(const Duration(minutes: 5));
    } finally {
      running = false;
    }
  }

  scheduleNext = (Duration interval) {
    timer?.cancel();
    timer = Timer(interval, () {
      runOnce('timer');
    });
  };

  service.on(BackgroundServiceCommands.stop).listen((_) async {
    timer?.cancel();
    coordinator.dispose();
    await service.stopSelf();
  });

  service.on(BackgroundServiceCommands.settingsChanged).listen((_) {
    runOnce('settingsChanged');
  });

  service.on(BackgroundServiceCommands.runOnce).listen((_) {
    runOnce('manual');
  });

  void handleAlertActuatorCommand(Map<String, dynamic>? event) {
    final commandType = event?['commandType']?.toString().trim();
    if (commandType == AlertActuatorCommandType.stopAll.code) {
      AlertSoundSessionManager.shared.stopAll();
      return;
    }
    if (commandType == AlertActuatorCommandType.stopEvent.code) {
      final eventId = event?['eventId']?.toString().trim();
      if (eventId != null && eventId.isNotEmpty) {
        AlertSoundSessionManager.shared.stopEvent(eventId);
      }
      return;
    }
    if (commandType != AlertActuatorCommandType.stopTarget.code) return;
    final targetId = event?['targetId']?.toString().trim();
    final type = event?['type']?.toString().trim();
    if (targetId == null || targetId.isEmpty || type == null || type.isEmpty) {
      return;
    }
    AlertSoundSessionManager.shared.stopTargetType(
      targetId: targetId,
      type: type,
    );
  }

  service.on(BackgroundServiceCommands.alertActuatorCommand).listen((event) {
    handleAlertActuatorCommand(event);
  });

  await runOnce('start');
}
