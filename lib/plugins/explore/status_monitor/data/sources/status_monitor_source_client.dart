import 'package:smart_xdrip/data/sources/glucose_source_http_result.dart';
import 'package:smart_xdrip/data/sources/nightscout_api_source.dart';
import 'package:smart_xdrip/data/sources/xdrip_http_source.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class StatusHttpResult {
  final bool reachable;
  final int? statusCode;
  final Duration elapsed;
  final dynamic data;
  final Object? error;

  const StatusHttpResult({
    required this.reachable,
    this.statusCode,
    required this.elapsed,
    this.data,
    this.error,
  });

  factory StatusHttpResult.fromSource(GlucoseSourceHttpResult result) {
    return StatusHttpResult(
      reachable: result.reachable,
      statusCode: result.statusCode,
      elapsed: result.elapsed,
      data: result.data,
      error: result.error,
    );
  }
}

abstract interface class StatusMonitorSourceClient {
  Future<StatusHttpResult> get(
    String path, {
    Map<String, Object?>? queryParameters,
  });

  Future<StatusHttpResult> checkService();

  Future<List<GlucoseReading>> loadEntries24h(DateTime now);
}

class NightscoutStatusMonitorSourceClient implements StatusMonitorSourceClient {
  final NightscoutApiSource source;

  const NightscoutStatusMonitorSourceClient({required this.source});

  @override
  Future<StatusHttpResult> get(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async {
    return StatusHttpResult.fromSource(
      await source.jsonGet(path, queryParameters: queryParameters),
    );
  }

  @override
  Future<StatusHttpResult> checkService() {
    return get('/api/v1/status.json');
  }

  @override
  Future<List<GlucoseReading>> loadEntries24h(DateTime now) {
    return source.range(
      from: now.subtract(const Duration(hours: 24)),
      to: now,
    );
  }
}

class XdripStatusMonitorSourceClient implements StatusMonitorSourceClient {
  final XdripHttpSource source;

  const XdripStatusMonitorSourceClient({required this.source});

  @override
  Future<StatusHttpResult> get(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async {
    final normalizedPath =
        path == '/status.json' ? '/api/v1/status.json' : path;
    return StatusHttpResult.fromSource(
      await source.jsonGet(normalizedPath, queryParameters: queryParameters),
    );
  }

  @override
  Future<StatusHttpResult> checkService() async {
    final started = DateTime.now();
    try {
      final available = await source.isAvailable();
      return StatusHttpResult(
        reachable: available,
        statusCode: available ? 200 : null,
        elapsed: DateTime.now().difference(started),
      );
    } catch (error) {
      return StatusHttpResult(
        reachable: false,
        elapsed: DateTime.now().difference(started),
        error: error,
      );
    }
  }

  @override
  Future<List<GlucoseReading>> loadEntries24h(DateTime now) {
    return source.recent(count: 288);
  }
}
