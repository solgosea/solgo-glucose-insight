import 'dart:io';

import 'package:dio/dio.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/glucose_trend/glucose_trend_enrichment_service.dart';
import '../../domain/glucose_trend/glucose_trend_sample.dart';
import '../../domain/sources/i_glucose_source.dart';
import 'glucose_source_http_result.dart';

/// xDrip+ Web Service HTTP source using Nightscout-style endpoints.
///
/// xDrip+ exposes a local HTTP server (default port 17580) on the same Android
/// device. We hit `127.0.0.1:17580` from this app. iOS does NOT support this
/// (xDrip+ is Android-only) — iOS users should configure Nightscout instead.
///
/// API endpoints:
///   GET /api/v1/entries/sgv.json?count=N   — recent glucose values
///   GET /api/v1/entries/sgv.json?find[date][$gte]=...&count=N  — range query
///   GET /pebble                            — current value + trend (lightweight)
///   GET /api/v1/status.json                — health check
///
/// Returned JSON sgv values are in mg/dL — we convert to mmol/L (÷ 18).
class XdripHttpSource implements IGlucoseSource {
  final String baseUrl;
  final String? apiSecret;
  final Dio _dio;

  XdripHttpSource({
    this.baseUrl = 'http://127.0.0.1:17580',
    this.apiSecret,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 2);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
    _dio.options.headers['Accept'] = 'application/json';
    if (apiSecret != null && apiSecret!.isNotEmpty) {
      _dio.options.headers['api-secret'] = apiSecret;
    }
  }

  @override
  DataSource get type => DataSource.xdripHttp;

  @override
  Future<bool> isAvailable() async {
    if (await _isPortOpen()) return true;
    try {
      final r = await _dio.get('/api/v1/status.json',
          options: Options(receiveTimeout: const Duration(seconds: 3)));
      return r.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _isPortOpen() async {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.host.isEmpty) return false;
    final port = uri.hasPort
        ? uri.port
        : uri.scheme == 'https'
            ? 443
            : 80;
    try {
      final socket = await Socket.connect(
        uri.host,
        port,
        timeout: const Duration(seconds: 2),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<GlucoseSourceHttpResult> jsonGet(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async {
    final started = DateTime.now();
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return GlucoseSourceHttpResult(
        reachable: response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 500,
        statusCode: response.statusCode,
        elapsed: DateTime.now().difference(started),
        data: response.data,
      );
    } catch (error) {
      return GlucoseSourceHttpResult(
        reachable: false,
        elapsed: DateTime.now().difference(started),
        error: error,
      );
    }
  }

  @override
  Future<GlucoseReading?> latest() async {
    final list = await recent(count: 1);
    return list.isEmpty ? null : list.last;
  }

  @override
  Future<List<GlucoseReading>> recent({int count = 24}) async {
    final r = await _dio.get(
      '/api/v1/entries/sgv.json',
      queryParameters: {'count': count},
    );
    return _parse(r.data);
  }

  @override
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  }) async {
    // xDrip+ supports MongoDB-style query operators: find[date][$gte], $lte
    final r = await _dio.get(
      '/api/v1/entries/sgv.json',
      queryParameters: {
        'find[date][\$gte]': from.millisecondsSinceEpoch,
        'find[date][\$lte]': to.millisecondsSinceEpoch,
        'count': _countForWindow(from, to),
      },
    );
    return _parse(r.data);
  }

  /// Parses xDrip+/Nightscout JSON entries into GlucoseReading.
  /// Each entry: { date: epochMs, sgv: mgDl, direction: "Flat" | ... }
  List<GlucoseReading> _parse(dynamic data) {
    if (data is! List) return [];
    final samples = <GlucoseTrendSample>[];
    for (final raw in data) {
      if (raw is! Map) continue;
      final date = raw['date'];
      final sgv = raw['sgv'];
      if (date is! num || sgv is! num) continue;
      final ts = DateTime.fromMillisecondsSinceEpoch(date.toInt());
      final mmol = sgv.toDouble() / 18.0;
      samples.add(
        GlucoseTrendSample(
          reading: GlucoseReading(timestamp: ts, value: mmol),
          direction: raw['direction']?.toString(),
        ),
      );
    }
    return const GlucoseTrendEnrichmentService().enrichSamples(samples);
  }

  int _countForWindow(DateTime from, DateTime to) {
    final minutes = to.difference(from).inMinutes.abs();
    final expectedFiveMinuteReadings = (minutes / 5).ceil();
    return expectedFiveMinuteReadings.clamp(24, 2000);
  }
}
