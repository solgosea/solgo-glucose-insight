import '../../../domain/data_source/data_source_kind.dart';
import '../../../domain/entities/app_settings.dart';
import '../../data_source/connection_test_result.dart';

abstract class DataSourceHealthHandler {
  DataSourceKind get kind;

  bool isConfigured(AppSettings settings);

  Future<ConnectionTestResult> check(AppSettings settings);
}
