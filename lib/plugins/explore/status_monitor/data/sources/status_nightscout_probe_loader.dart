import '../../domain/detail/status_endpoint_probe.dart';
import '../../domain/detail/status_probe_message_sanitizer.dart';
import '../../domain/detail/status_response_time_point.dart';
import '../../domain/status_level.dart';
import 'status_monitor_source_client.dart';

class StatusNightscoutProbeBundle {
  final List<StatusEndpointProbe> endpoints;
  final List<StatusResponseTimePoint> responsePoints;
  final StatusHttpResult? entriesResult;
  final StatusHttpResult? deviceStatusResult;

  const StatusNightscoutProbeBundle({
    required this.endpoints,
    required this.responsePoints,
    this.entriesResult,
    this.deviceStatusResult,
  });
}

class StatusNightscoutProbeLoader {
  final StatusMonitorSourceClient client;
  final StatusProbeMessageSanitizer messageSanitizer;

  const StatusNightscoutProbeLoader({
    required this.client,
    this.messageSanitizer = const StatusProbeMessageSanitizer(),
  });

  Future<StatusNightscoutProbeBundle> load({required DateTime now}) async {
    final status = await client.get('/api/v1/status.json');
    final entries = await client.get(
      '/api/v1/entries/sgv.json',
      queryParameters: {'count': 12},
    );
    final deviceStatus = await client.get(
      '/api/v1/devicestatus.json',
      queryParameters: {'count': 10},
    );
    final endpoints = [
      _endpoint(
        label: 'status.json',
        endpoint: '/api/v1/status.json',
        result: status,
        now: now,
      ),
      _endpoint(
        label: 'entries',
        endpoint: '/api/v1/entries/sgv.json',
        result: entries,
        now: now,
      ),
      _endpoint(
        label: 'devicestatus',
        endpoint: '/api/v1/devicestatus.json',
        result: deviceStatus,
        now: now,
        optional: true,
      ),
    ];
    return StatusNightscoutProbeBundle(
      endpoints: endpoints,
      responsePoints: endpoints
          .map(
            (endpoint) => StatusResponseTimePoint(
              at: now,
              elapsed: endpoint.elapsed,
              level: endpoint.level,
              endpoint: endpoint.endpoint,
              timeout: !endpoint.reachable,
            ),
          )
          .toList(growable: false),
      entriesResult: entries,
      deviceStatusResult: deviceStatus,
    );
  }

  StatusEndpointProbe _endpoint({
    required String label,
    required String endpoint,
    required StatusHttpResult result,
    required DateTime now,
    bool optional = false,
  }) {
    final level = _level(result, optional: optional);
    return StatusEndpointProbe(
      endpoint: endpoint,
      label: label,
      level: level,
      reachable: result.reachable,
      statusCode: result.statusCode,
      elapsed: result.elapsed,
      checkedAt: now,
      message: messageSanitizer.fromHttpResult(
        reachable: result.reachable,
        statusCode: result.statusCode,
        error: result.error,
      ),
    );
  }

  StatusLevel _level(StatusHttpResult result, {required bool optional}) {
    if (!result.reachable) {
      return optional ? StatusLevel.unknown : StatusLevel.issue;
    }
    final code = result.statusCode ?? 0;
    if (code == 401 || code == 403 || code >= 500) return StatusLevel.issue;
    if (code != 200) return optional ? StatusLevel.unknown : StatusLevel.watch;
    if (result.elapsed > const Duration(seconds: 3)) return StatusLevel.issue;
    if (result.elapsed > const Duration(milliseconds: 500)) {
      return StatusLevel.watch;
    }
    if (optional &&
        (result.data == null ||
            result.data is List && (result.data as List).isEmpty)) {
      return StatusLevel.unknown;
    }
    return StatusLevel.healthy;
  }
}
