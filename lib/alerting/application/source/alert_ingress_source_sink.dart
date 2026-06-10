import '../../domain/source/alert_input.dart';
import '../../domain/source/alert_source_sink.dart';
import '../ingress/alert_ingress.dart';

class AlertIngressSourceSink implements AlertSourceSink {
  final AlertIngress ingress;

  const AlertIngressSourceSink({required this.ingress});

  @override
  Future<void> ingest(AlertInput input) {
    return ingress.enqueue(
      messageType: input.messageType,
      source: input.origin.code,
      targetPluginId: input.targetPluginId,
      targetId: input.targetId,
      subjectId: input.subjectId,
      alertEventId: input.alertEventId,
      alertType: input.alertType,
      priority: input.priority,
      payload: input.payload,
      dedupeKey:
          input.dedupeKey ??
          [
            input.sourceId.value,
            input.messageType,
            input.alertEventId,
            input.subjectId,
            input.alertType,
          ].whereType<String>().join(':'),
      canonicalSourceKey: input.canonicalSourceKey,
      dedupeScope: input.dedupeScope,
      sourcePriority: input.sourcePriority,
      availableAt: input.availableAt,
    );
  }
}
