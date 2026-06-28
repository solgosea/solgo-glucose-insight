import 'dart:async';

import 'package:smart_xdrip/application/data_source_runtime/data_source_runtime_coordinator.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';

import '../alert_source/local_glucose_alert_source.dart';

class DatasourcePluginRuntime implements PluginRuntime {
  static const id = PluginId('datasource.core');

  final DataSourceRuntimeCoordinator coordinator;
  final AppSettings Function() settingsProvider;
  final LocalGlucoseAlertSource? alertSource;
  StreamSubscription<PluginRuntimeEvent>? _subscription;

  DatasourcePluginRuntime({
    required this.coordinator,
    required this.settingsProvider,
    this.alertSource,
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    final settings = settingsProvider();
    await coordinator.start(settings);
    _subscription ??= context.eventBus.events.listen((event) {
      if (event.type == PluginRuntimeEventType.subjectDataChanged) {
        unawaited(alertSource?.evaluateCurrentSubject(
          trigger: event.payload['trigger']?.toString() ?? 'subjectDataChanged',
        ));
      }
    });
    await alertSource?.evaluateCurrentSubject(trigger: 'runtimeStart');
    _publishSnapshot(context);
  }

  @override
  Future<void> resume(PluginRuntimeContext context) async {
    final settings = settingsProvider();
    await coordinator.updateSettings(settings);
    await alertSource?.evaluateCurrentSubject(trigger: 'runtimeResume');
    _publishSnapshot(context);
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {}

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
    coordinator.dispose();
  }

  void _publishSnapshot(PluginRuntimeContext context) {
    context.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.datasourceChanged,
        targetPluginId: pluginId,
        occurredAt: context.now(),
        payload: {
          'name': 'datasource.snapshot',
          'snapshots': coordinator.snapshots
              .map(
                (snapshot) => {
                  'kind': snapshot.kind.name,
                  'healthStatus': snapshot.healthStatus.name,
                  'supported': snapshot.supported,
                  'configured': snapshot.configured,
                  'active': snapshot.active,
                  'reachable': snapshot.reachable,
                },
              )
              .toList(growable: false),
        },
      ),
    );
  }
}
