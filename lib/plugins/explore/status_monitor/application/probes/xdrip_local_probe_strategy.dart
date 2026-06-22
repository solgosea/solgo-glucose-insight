import 'package:smart_xdrip/data/sources/xdrip_http_source.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../data/sources/status_monitor_source_client.dart';
import '../../data/sources/status_xdrip_local_probe_loader.dart';
import '../../domain/evidence/xdrip_local_evidence.dart';
import '../status_monitor_target_resolution.dart';
import 'status_probe_strategy.dart';

class XdripLocalProbeStrategy
    implements StatusProbeStrategy<XdripLocalEvidence> {
  final StatusMonitorTargetResolution? resolution;
  final DateTime now;

  const XdripLocalProbeStrategy({
    required this.resolution,
    required this.now,
  });

  @override
  Future<XdripLocalEvidence> probe() async {
    final target = resolution;
    if (target == null || !target.hasConfiguredSource) {
      return const XdripLocalEvidence.none(
        failureLabel: 'xDrip+ Local is not configured.',
      );
    }
    final baseUrl = target.baseUrl?.trim();
    if (baseUrl == null || baseUrl.isEmpty) {
      return const XdripLocalEvidence.none(
        failureLabel: 'xDrip+ Local URL is missing.',
      );
    }

    final client = XdripStatusMonitorSourceClient(
      source: XdripHttpSource(
        baseUrl: baseUrl,
        apiSecret: target.token,
      ),
    );
    try {
      final bundle = await StatusXdripLocalProbeLoader(client: client).load(
        now: now,
      );
      return XdripLocalEvidence(
        configured: true,
        enabled: true,
        sourceTargetId: target.targetId,
        sourceLabel: target.sourceLabel,
        generatedAt: now,
        serviceProbe: bundle.statusProbe,
        readings: await _safeEntries(client),
        pebble: bundle.pebble,
        sensorContext: bundle.sensorContext,
        collectorContext: bundle.collectorContext,
      );
    } catch (_) {
      return XdripLocalEvidence(
        configured: true,
        enabled: true,
        sourceTargetId: target.targetId,
        sourceLabel: target.sourceLabel,
        generatedAt: now,
        failureLabel: 'xDrip+ Local probe failed.',
      );
    }
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
}
