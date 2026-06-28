import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';

class DatasourceProfileViewModel {
  final List<DatasourceProfileSourceViewModel> sources;
  final String runtimeLimitationText;
  final String foregroundReconcileLabel;
  final bool refreshing;
  final String? recoverableErrorText;

  const DatasourceProfileViewModel({
    required this.sources,
    this.runtimeLimitationText = '',
    this.foregroundReconcileLabel = '',
    this.refreshing = false,
    this.recoverableErrorText,
  });
}

class DatasourceProfileSourceViewModel {
  final DataSourceKind kind;
  final DataSourceConnectionAction action;
  final DataSourceSyncStrategyAction strategyAction;
  final DatasourceProfileActionStyle actionStyle;
  final String name;
  final String subtitle;
  final String? meta;
  final SyncStatusViewModel? syncStatus;
  final String trailing;
  final String? secondaryTrailing;
  final DataSourceConnectionAction? secondaryAction;
  final Color statusColor;
  final bool active;
  final bool actionEnabled;
  final bool strategyActionEnabled;
  final bool pulsing;
  final bool checking;
  final bool muted;

  const DatasourceProfileSourceViewModel({
    required this.kind,
    required this.action,
    required this.strategyAction,
    required this.actionStyle,
    required this.name,
    required this.subtitle,
    required this.meta,
    this.syncStatus,
    required this.trailing,
    this.secondaryTrailing,
    this.secondaryAction,
    required this.statusColor,
    required this.active,
    required this.actionEnabled,
    required this.strategyActionEnabled,
    required this.pulsing,
    this.checking = false,
    required this.muted,
  });
}

enum DatasourceProfileActionStyle {
  primary,
  secondary,
  warning,
  destructive,
  disabled,
}
