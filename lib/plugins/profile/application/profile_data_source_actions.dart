import '../../../application/data_source/connection_test_result.dart';
import '../../../application/data_source/data_source_connection_result.dart';
import '../../../domain/data_source/data_source_kind.dart';

class ProfileDataSourceActions {
  final Future<ConnectionTestResult> Function() detectXdripLocal;
  final Future<ConnectionTestResult> Function() connectXdripLocal;
  final Future<DataSourceConnectionResult> Function({
    required String baseUrl,
    String? token,
  })
  connectNightscout;
  final Future<DataSourceConnectionResult> Function() useConfiguredNightscout;
  final Future<DataSourceConnectionResult> Function(DataSourceKind kind)
  disconnectDataSource;
  final Future<DataSourceConnectionResult> Function(DataSourceKind kind)
  enableDataSourceSync;
  final Future<DataSourceConnectionResult> Function(DataSourceKind kind)
  disableDataSourceSync;

  const ProfileDataSourceActions({
    required this.detectXdripLocal,
    required this.connectXdripLocal,
    required this.connectNightscout,
    required this.useConfiguredNightscout,
    required this.disconnectDataSource,
    required this.enableDataSourceSync,
    required this.disableDataSourceSync,
  });
}
