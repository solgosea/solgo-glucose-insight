import '../../domain/detail/status_endpoint_probe.dart';
import '../../domain/detail/status_probe_message_sanitizer.dart';
import '../../domain/status_level.dart';
import 'status_monitor_source_client.dart';

class StatusXdripLocalProbeBundle {
  final StatusEndpointProbe? statusProbe;
  final Map<String, dynamic>? status;
  final Map<String, dynamic>? pebble;
  final Map<String, dynamic>? sensorContext;
  final Map<String, dynamic>? collectorContext;

  const StatusXdripLocalProbeBundle({
    this.statusProbe,
    this.status,
    this.pebble,
    this.sensorContext,
    this.collectorContext,
  });
}

class StatusXdripLocalProbeLoader {
  final StatusMonitorSourceClient client;
  final StatusProbeMessageSanitizer messageSanitizer;

  const StatusXdripLocalProbeLoader({
    required this.client,
    this.messageSanitizer = const StatusProbeMessageSanitizer(),
  });

  Future<StatusXdripLocalProbeBundle> load({required DateTime now}) async {
    final service = await client.checkService();
    final status = await _safeGet('/status.json');
    final pebble = await _safeGet('/pebble');
    final sensor =
        await _safeGet('/sgv.json', queryParameters: {'sensor': 'Y'});
    final collector = await _safeGet(
      '/sgv.json',
      queryParameters: {'collector': 'Y'},
    );
    return StatusXdripLocalProbeBundle(
      statusProbe: StatusEndpointProbe(
        endpoint: '/status.json',
        label: 'local service',
        level: _level(service),
        reachable: service.reachable,
        statusCode: service.statusCode,
        elapsed: service.elapsed,
        checkedAt: now,
        message: service.reachable
            ? 'xDrip+ Local service is reachable.'
            : messageSanitizer.fromHttpResult(
                reachable: service.reachable,
                statusCode: service.statusCode,
                error: service.error,
              ),
      ),
      status: _map(status?.data),
      pebble: _map(pebble?.data),
      sensorContext: _map(sensor?.data),
      collectorContext: _map(collector?.data),
    );
  }

  Future<StatusHttpResult?> _safeGet(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      return await client.get(path, queryParameters: queryParameters);
    } catch (_) {
      return null;
    }
  }

  StatusLevel _level(StatusHttpResult result) {
    if (!result.reachable) return StatusLevel.issue;
    final code = result.statusCode ?? 0;
    if (code == 401 || code == 403 || code >= 500) return StatusLevel.issue;
    if (code != 200) return StatusLevel.watch;
    if (result.elapsed > const Duration(seconds: 3)) return StatusLevel.issue;
    if (result.elapsed > const Duration(milliseconds: 500)) {
      return StatusLevel.watch;
    }
    return StatusLevel.healthy;
  }

  Map<String, dynamic>? _map(Object? data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is List && data.isNotEmpty && data.first is Map) {
      return Map<String, dynamic>.from(data.first as Map);
    }
    return null;
  }
}
