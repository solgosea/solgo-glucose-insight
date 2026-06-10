import '../../../domain/data_source/data_source_kind.dart';
import '../../../domain/entities/app_settings.dart';
import '../../data_source/connection_test_result.dart';
import '../../data_source/data_source_connection_service.dart';
import 'data_source_health_handler.dart';

class XdripLocalHealthHandler implements DataSourceHealthHandler {
  final DataSourceConnectionService service;

  const XdripLocalHealthHandler({
    this.service = const DataSourceConnectionService(),
  });

  @override
  DataSourceKind get kind => DataSourceKind.xdripLocal;

  @override
  bool isConfigured(AppSettings settings) => true;

  @override
  Future<ConnectionTestResult> check(AppSettings settings) {
    return service.testXdripLocal(
      baseUrl:
          settings.xdripBaseUrl ?? DataSourceConnectionService.defaultXdripUrl,
      apiSecret: settings.xdripApiSecret,
    );
  }
}
