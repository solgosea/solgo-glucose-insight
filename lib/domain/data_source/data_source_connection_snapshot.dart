import '../entities/source_sync_state.dart';
import 'data_source_action.dart';
import 'data_source_connection_status.dart';
import 'data_source_kind.dart';
import 'data_source_sync_strategy_action.dart';

class DataSourceConnectionSnapshot {
  final DataSourceKind kind;
  final DataSourceConnectionStatus status;
  final DataSourceConnectionAction action;
  final DataSourceSyncStrategyAction strategyAction;
  final String title;
  final String subtitle;
  final String trailing;
  final String strategyTrailing;
  final bool active;
  final bool detected;
  final bool configured;
  final bool strategyEnabled;
  final bool supported;
  final SourceSyncState? syncState;

  const DataSourceConnectionSnapshot({
    required this.kind,
    required this.status,
    required this.action,
    required this.strategyAction,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.strategyTrailing,
    required this.active,
    required this.detected,
    required this.configured,
    required this.strategyEnabled,
    required this.supported,
    this.syncState,
  });
}
