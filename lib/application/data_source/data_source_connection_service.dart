import 'package:smart_xdrip/data/sources/nightscout_api_source.dart';
import 'package:smart_xdrip/data/sources/xdrip_http_source.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../nightscout/nightscout_url_normalizer.dart';
import 'connection_test_result.dart';

class DataSourceConnectionService {
  static const defaultXdripUrl = 'http://127.0.0.1:17580';

  const DataSourceConnectionService();

  Future<ConnectionTestResult> testXdripLocal({
    String baseUrl = defaultXdripUrl,
    String? apiSecret,
  }) async {
    try {
      final source = XdripHttpSource(baseUrl: baseUrl, apiSecret: apiSecret);
      final available = await source.isAvailable();
      return available
          ? ConnectionTestResult.success(
            'xDrip+ Local is reachable at $baseUrl',
          )
          : ConnectionTestResult.failure(
            'xDrip+ Local was not detected at $baseUrl',
          );
    } catch (_) {
      return ConnectionTestResult.failure(
        'xDrip+ Local was not detected at $baseUrl',
      );
    }
  }

  Future<ConnectionTestResult> testNightscout({
    required String baseUrl,
    String? token,
  }) async {
    final normalized = normalizeUrl(baseUrl);
    if (normalized == null) {
      return const ConnectionTestResult.failure('Enter a valid Nightscout URL');
    }
    try {
      final source = NightscoutApiSource(baseUrl: normalized, token: token);
      final available = await source.isAvailable();
      return available
          ? ConnectionTestResult.success(
            'Nightscout API is reachable at $normalized',
          )
          : ConnectionTestResult.failure(
            'Nightscout API did not respond at $normalized',
          );
    } catch (_) {
      return ConnectionTestResult.failure(
        'Nightscout API did not respond at $normalized',
      );
    }
  }

  AppSettings connectXdripLocal({
    required AppSettings settings,
    String baseUrl = defaultXdripUrl,
    String? apiSecret,
  }) {
    return settings.copyWith(
      xdripBaseUrl: normalizeUrl(baseUrl) ?? defaultXdripUrl,
      xdripApiSecret: apiSecret ?? '',
    );
  }

  AppSettings connectNightscout({
    required AppSettings settings,
    required String baseUrl,
    String? token,
  }) {
    return settings.copyWith(
      nightscoutBaseUrl: normalizeUrl(baseUrl),
      nightscoutToken: token ?? '',
    );
  }

  String? normalizeUrl(String raw) {
    return NightscoutUrlNormalizer.normalize(raw);
  }
}
