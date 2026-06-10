import 'dart:async';

import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/ingress/alerting_center.dart';
import '../application/queue/alert_queue_consumer.dart';
import '../application/source/alert_ingress_source_sink.dart';
import '../application/source/alert_source_registry.dart';

class AlertingPluginRuntime implements PluginRuntime {
  static const id = PluginId('core.alerting');

  final AlertingCenter alertingCenter;
  final AlertQueueConsumer queueConsumer;
  final AlertSourceRegistry sourceRegistry;
  final AlertIngressSourceSink sourceSink;

  StreamSubscription<PluginRuntimeEvent>? _runtimeSubscription;

  AlertingPluginRuntime({
    required this.alertingCenter,
    required this.queueConsumer,
    required this.sourceRegistry,
    required this.sourceSink,
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.runtime;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    queueConsumer.scheduleDrain();
    await sourceRegistry.startAll(sourceSink);
    _runtimeSubscription ??= context.eventBus.events.listen((event) {
      if (event.type == PluginRuntimeEventType.subjectDataChanged) {
        _handleSubjectDataChanged(context, event);
      }
    });
  }

  @override
  Future<void> resume(PluginRuntimeContext context) async {
    context.markRunning(pluginId);
    await sourceRegistry.startAll(sourceSink);
    queueConsumer.scheduleDrain();
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {
    // Alert delivery should remain available while the user navigates.
  }

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _runtimeSubscription?.cancel();
    _runtimeSubscription = null;
    await sourceRegistry.stopAll();
  }

  void _handleSubjectDataChanged(
    PluginRuntimeContext context,
    PluginRuntimeEvent event,
  ) {
    context.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.custom,
        targetPluginId: pluginId,
        occurredAt: context.now(),
        payload: {
          'name': 'alerting.subjectDataObserved',
          'subjectIds': event.payload['subjectIds'],
          'trigger': event.payload['trigger'],
        },
      ),
    );
  }
}
