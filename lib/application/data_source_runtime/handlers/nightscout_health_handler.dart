import '../../../domain/data_source/data_source_kind.dart';
import '../../../domain/entities/app_settings.dart';
import '../../data_source/connection_test_result.dart';
import '../../data_source/data_source_connection_service.dart';
import 'data_source_health_handler.dart';

class NightscoutHealthHandler implements DataSourceHealthHandler {
  final DataSourceConnectionService service;

  const NightscoutHealthHandler({
    this.service = const DataSourceConnectionService(),
  });

  @override
  DataSourceKind get kind => DataSourceKind.nightscout;

  @override
  bool isConfigured(AppSettings settings) {
    final baseUrl = settings.nightscoutBaseUrl;
    return baseUrl != null && baseUrl.trim().isNotEmpty;
  }

  @override
  Future<ConnectionTestResult> check(AppSettings settings) {
    final baseUrl = settings.nightscoutBaseUrl;
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return Future.value(
        const ConnectionTestResult.failure('Nightscout API is not configured'),
      );
    }
    return service.testNightscout(
      baseUrl: baseUrl,
      token: settings.nightscoutToken,
    );
  }
}
