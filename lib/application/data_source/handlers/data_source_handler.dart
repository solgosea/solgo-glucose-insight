import '../../../domain/data_source/data_source_connection_snapshot.dart';
import '../../../domain/data_source/data_source_kind.dart';
import '../../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/source_sync_state.dart';
import '../data_source_connection_config.dart';
import '../data_source_connection_result.dart';

abstract class DataSourceHandler {
  DataSourceKind get kind;

  Future<DataSourceConnectionSnapshot> snapshot({
    required AppSettings settings,
    SourceSyncState? syncState,
    required bool supported,
    DataSourceRuntimeSnapshot? runtime,
  });

  Future<DataSourceConnectionResult> connect({
    required AppSettings settings,
    DataSourceConnectionConfig config = const DataSourceConnectionConfig(),
  });

  Future<DataSourceConnectionResult> disconnect({
    required AppSettings settings,
  });
}
