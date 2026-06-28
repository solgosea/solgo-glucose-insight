import 'package:dio/dio.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/glucose_trend/glucose_trend_enrichment_service.dart';
import '../../domain/glucose_trend/glucose_trend_sample.dart';
import '../../domain/sources/i_glucose_source.dart';
import 'glucose_source_http_result.dart';

/// Nightscout REST API source — for reading glucose data uploaded by
/// xDrip+ / xDrip4iOS / Loop / etc. to a user-hosted Nightscout instance.
///
/// Works on both Android and iOS.
///
/// Auth: Nightscout uses either ?token=<readable_token> query param
/// or api-secret header (SHA1 of API_SECRET).
class NightscoutApiSource implements IGlucoseSource {
  final String baseUrl;
  final String? token;
  final Dio _dio;

  NightscoutApiSource({
    required this.baseUrl,
    this.token,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 8);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers['Accept'] = 'application/json';
    if (token != null && token!.isNotEmpty) {
      _dio.options.queryParameters['token'] = token;
    }
  }

  @override
  DataSource get type => DataSource.nightscout;

  @override
  Future<bool> isAvailable() async {
    try {
      final r = await _dio.get('/api/v1/status.json');
      return r.statusCode == 200;
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
      '/api/v1/entries.json',
      queryParameters: {
        'find[type]': 'sgv',
        'count': count,
      },
    );
    return _parse(r.data);
  }

  @override
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  }) async {
    final r = await _dio.get(
      '/api/v1/entries.json',
      queryParameters: {
        'find[type]': 'sgv',
        'find[date][\$gte]': from.millisecondsSinceEpoch,
        'find[date][\$lte]': to.millisecondsSinceEpoch,
        'count': _countForWindow(from, to),
      },
    );
    return _parse(r.data);
  }

  List<GlucoseReading> _parse(dynamic data) {
    if (data is! List) return [];
    final samples = <GlucoseTrendSample>[];
    for (final raw in data) {
      if (raw is! Map) continue;
      final date = raw['date'];
      final sgv = raw['sgv'];
      if (date is! num || sgv is! num) continue;
      samples.add(
        GlucoseTrendSample(
          reading: GlucoseReading(
            timestamp: DateTime.fromMillisecondsSinceEpoch(date.toInt()),
            value: sgv.toDouble() / 18.0,
          ),
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
