import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../detail/status_endpoint_probe.dart';
import 'status_device_service_evidence.dart';

class XdripLocalEvidence {
  final bool configured;
  final bool enabled;
  final String? sourceTargetId;
  final String sourceLabel;
  final DateTime? generatedAt;
  final StatusEndpointProbe? serviceProbe;
  final List<GlucoseReading> readings;
  final Map<String, dynamic>? pebble;
  final Map<String, dynamic>? sensorContext;
  final Map<String, dynamic>? collectorContext;
  final String? failureLabel;

  const XdripLocalEvidence({
    required this.configured,
    required this.enabled,
    this.sourceTargetId,
    required this.sourceLabel,
    this.generatedAt,
    this.serviceProbe,
    this.readings = const [],
    this.pebble,
    this.sensorContext,
    this.collectorContext,
    this.failureLabel,
  });

  const XdripLocalEvidence.none({
    this.sourceLabel = 'xDrip+ Local',
    this.failureLabel,
  })  : configured = false,
        enabled = false,
        sourceTargetId = null,
        generatedAt = null,
        serviceProbe = null,
        readings = const [],
        pebble = null,
        sensorContext = null,
        collectorContext = null;

  bool get serviceAvailable => serviceProbe?.reachable == true;
  bool get hasReadings => readings.isNotEmpty;

  StatusDeviceServiceEvidence get deviceService => StatusDeviceServiceEvidence(
        configured: configured,
        enabled: enabled,
        sourceTargetId: sourceTargetId,
        sourceLabel: sourceLabel,
        generatedAt: generatedAt,
        probe: serviceProbe,
        failureLabel: failureLabel,
      );
}
