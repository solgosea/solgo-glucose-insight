import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../detail/status_endpoint_probe.dart';
import '../detail/status_response_snapshot.dart';
import '../detail/status_response_time_point.dart';

class NightscoutEvidence {
  final bool configured;
  final bool enabled;
  final String? sourceTargetId;
  final String sourceLabel;
  final DateTime? generatedAt;
  final StatusResponseSnapshot? status;
  final List<Map<String, dynamic>> rawEntries;
  final List<Map<String, dynamic>> deviceStatus;
  final List<StatusEndpointProbe> endpointProbes;
  final List<StatusResponseTimePoint> responseTimeline;
  final List<GlucoseReading> readings;
  final String? failureLabel;

  const NightscoutEvidence({
    required this.configured,
    required this.enabled,
    this.sourceTargetId,
    required this.sourceLabel,
    this.generatedAt,
    this.status,
    this.rawEntries = const [],
    this.deviceStatus = const [],
    this.endpointProbes = const [],
    this.responseTimeline = const [],
    this.readings = const [],
    this.failureLabel,
  });

  const NightscoutEvidence.none({
    this.sourceLabel = 'Nightscout',
    this.failureLabel,
  })  : configured = false,
        enabled = false,
        sourceTargetId = null,
        generatedAt = null,
        status = null,
        rawEntries = const [],
        deviceStatus = const [],
        endpointProbes = const [],
        responseTimeline = const [],
        readings = const [];

  NightscoutEvidence copyWith({
    List<StatusResponseTimePoint>? responseTimeline,
  }) {
    return NightscoutEvidence(
      configured: configured,
      enabled: enabled,
      sourceTargetId: sourceTargetId,
      sourceLabel: sourceLabel,
      generatedAt: generatedAt,
      status: status,
      rawEntries: rawEntries,
      deviceStatus: deviceStatus,
      endpointProbes: endpointProbes,
      responseTimeline: responseTimeline ?? this.responseTimeline,
      readings: readings,
      failureLabel: failureLabel,
    );
  }

  bool get apiAvailable => status?.reachable == true;
  bool get hasReadings => readings.isNotEmpty;
}
