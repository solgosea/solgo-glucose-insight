import '../data_source/data_source_kind.dart';
import '../entities/source_sync_state.dart';
import 'data_source_health_status.dart';

class DataSourceRuntimeSnapshot {
  final DataSourceKind kind;
  final DataSourceHealthStatus healthStatus;
  final bool supported;
  final bool configured;
  final bool active;
  final DateTime? lastCheckedAt;
  final String? lastHealthMessage;
  final SourceSyncState? syncState;

  const DataSourceRuntimeSnapshot({
    required this.kind,
    required this.healthStatus,
    required this.supported,
    required this.configured,
    required this.active,
    this.lastCheckedAt,
    this.lastHealthMessage,
    this.syncState,
  });

  bool get reachable => healthStatus == DataSourceHealthStatus.reachable;
}
