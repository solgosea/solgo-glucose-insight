import 'package:smart_xdrip/data/sources/nightscout_api_source.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../data/sources/status_device_status_loader.dart';
import '../../data/sources/status_monitor_source_client.dart';
import '../../data/sources/status_nightscout_loader.dart';
import '../../data/sources/status_nightscout_probe_loader.dart';
import '../../domain/detail/status_response_snapshot.dart';
import '../../domain/evidence/nightscout_evidence.dart';
import '../status_monitor_target_resolution.dart';
import 'status_probe_strategy.dart';

class NightscoutProbeStrategy
    implements StatusProbeStrategy<NightscoutEvidence> {
  final StatusMonitorTargetResolution? resolution;
  final DateTime now;

  const NightscoutProbeStrategy({
    required this.resolution,
    required this.now,
  });

  @override
  Future<NightscoutEvidence> probe() async {
    final target = resolution;
    if (target == null || !target.hasConfiguredSource) {
      return const NightscoutEvidence.none(
        failureLabel: 'Nightscout is not configured.',
      );
    }
    if (!target.enabled) {
      return NightscoutEvidence.none(
        sourceLabel: target.sourceLabel,
        failureLabel: target.unavailableReason ??
            'Nightscout is configured but disabled.',
      );
    }
    final baseUrl = target.baseUrl?.trim();
    if (baseUrl == null || baseUrl.isEmpty) {
      return const NightscoutEvidence.none(
        failureLabel: 'Nightscout URL is missing.',
      );
    }

    final client = NightscoutStatusMonitorSourceClient(
      source: NightscoutApiSource(
        baseUrl: baseUrl,
        token: target.token,
      ),
    );
    final entries = await _safeEntries(client);
    final status = await _safeStatus(client);
    final deviceStatus = await _safeDeviceStatus(client);
    final probes = await _safeProbes(client);
    return NightscoutEvidence(
      configured: true,
      enabled: true,
      sourceTargetId: target.targetId,
      sourceLabel: target.sourceLabel,
      generatedAt: now,
      status: status,
      rawEntries: _rawRows(probes.entriesResult?.data),
      deviceStatus: deviceStatus,
      endpointProbes: probes.endpoints,
      responseTimeline: probes.responsePoints,
      readings: entries,
    );
  }

  Future<List<GlucoseReading>> _safeEntries(
    StatusMonitorSourceClient client,
  ) async {
    try {
      return await client.loadEntries24h(now);
    } catch (_) {
      return const [];
    }
  }

  Future<StatusResponseSnapshot?> _safeStatus(
    StatusMonitorSourceClient client,
  ) async {
    try {
      return await StatusNightscoutLoader(client: client).loadStatus();
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _safeDeviceStatus(
    StatusMonitorSourceClient client,
  ) async {
    try {
      return await StatusDeviceStatusLoader(client: client).loadDeviceStatus();
    } catch (_) {
      return const [];
    }
  }

  Future<StatusNightscoutProbeBundle> _safeProbes(
    StatusMonitorSourceClient client,
  ) async {
    try {
      return await StatusNightscoutProbeLoader(client: client).load(now: now);
    } catch (_) {
      return const StatusNightscoutProbeBundle(
        endpoints: [],
        responsePoints: [],
      );
    }
  }

  List<Map<String, dynamic>> _rawRows(Object? data) {
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList(growable: false);
  }
}
