import 'package:smart_xdrip/data/sources/nightscout_api_source.dart';
import 'package:smart_xdrip/data/sources/xdrip_http_source.dart';
import '../../../data/sources/status_monitor_source_client.dart';
import '../../../domain/probe/status_probe_definition.dart';
import '../../../domain/probe/status_probe_evidence.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_severity.dart';
import '../../../domain/probe/status_probe_signal.dart';
import '../../../domain/probe/status_probe_source_ref.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../status_monitor_target_resolution.dart';

typedef StatusProbeClientFactory = StatusMonitorSourceClient? Function(
  StatusMonitorTargetResolution target,
);

StatusProbeResult probeResult({
  required StatusProbeDefinition definition,
  required StatusProbeState state,
  required DateTime observedAt,
  required String summary,
  required double confidence,
  Duration? elapsed,
  List<StatusProbeSignal> signals = const [],
  List<StatusProbeEvidence> evidence = const [],
  List<StatusProbeSourceRef> sourceRefs = const [],
}) {
  return StatusProbeResult(
    definition: definition,
    state: state,
    observedAt: observedAt,
    confidence: confidence.clamp(0, 1),
    runMode: definition.runMode,
    summary: summary,
    elapsed: elapsed,
    signals: signals,
    evidence: evidence,
    sourceRefs: sourceRefs,
  );
}

StatusProbeSignal signal(
  String label,
  String value, {
  StatusProbeSeverity severity = StatusProbeSeverity.info,
}) {
  return StatusProbeSignal(
    label: label,
    value: value,
    severity: severity,
  );
}

StatusProbeEvidence evidence(
  String label,
  String value, {
  DateTime? observedAt,
  Map<String, Object?> metadata = const {},
}) {
  return StatusProbeEvidence(
    label: label,
    value: value,
    observedAt: observedAt,
    metadata: metadata,
  );
}

StatusProbeSourceRef sourceRef(String source, String path, [String? detail]) {
  return StatusProbeSourceRef(source: source, path: path, detail: detail);
}

StatusMonitorSourceClient? nightscoutClientFrom(
  StatusMonitorTargetResolution target,
) {
  if (target.sourceKind != StatusMonitorTargetSourceKind.nightscout) {
    return null;
  }
  final baseUrl = target.baseUrl?.trim();
  if (baseUrl == null || baseUrl.isEmpty || !target.enabled) return null;
  return NightscoutStatusMonitorSourceClient(
    source: NightscoutApiSource(baseUrl: baseUrl, token: target.token),
  );
}

StatusMonitorSourceClient? xdripClientFrom(
  StatusMonitorTargetResolution target,
) {
  if (target.sourceKind != StatusMonitorTargetSourceKind.xdripLocal) {
    return null;
  }
  final baseUrl = target.baseUrl?.trim();
  if (baseUrl == null || baseUrl.isEmpty || !target.enabled) return null;
  return XdripStatusMonitorSourceClient(
    source: XdripHttpSource(baseUrl: baseUrl, apiSecret: target.token),
  );
}

StatusProbeResult notConfigured({
  required StatusProbeDefinition definition,
  required DateTime observedAt,
  required String summary,
}) {
  return probeResult(
    definition: definition,
    state: StatusProbeState.notConfigured,
    observedAt: observedAt,
    summary: summary,
    confidence: 0,
    sourceRefs: [sourceRef(definition.id.value, 'configuration')],
  );
}
