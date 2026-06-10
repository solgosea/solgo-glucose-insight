import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';

class ProfileViewModel {
  final ProfileHeaderViewModel header;
  final List<ProfileStatViewModel> stats;
  final List<ProfileDataSourceViewModel> dataSources;
  final List<ProfileTargetRangeViewModel> targetRanges;
  final String appSettingsSummary;

  const ProfileViewModel({
    required this.header,
    required this.stats,
    required this.dataSources,
    required this.targetRanges,
    required this.appSettingsSummary,
  });
}

class ProfileHeaderViewModel {
  final String title;
  final String primaryBadge;

  const ProfileHeaderViewModel({
    required this.title,
    required this.primaryBadge,
  });
}

class ProfileStatViewModel {
  final String value;
  final String? unit;
  final String label;
  final Color valueColor;

  const ProfileStatViewModel({
    required this.value,
    this.unit,
    required this.label,
    required this.valueColor,
  });
}

class ProfileDataSourceViewModel {
  final DataSourceKind kind;
  final DataSourceConnectionAction action;
  final DataSourceSyncStrategyAction strategyAction;
  final ProfileDataSourceActionStyle actionStyle;
  final ProfileDataSourceActionStyle strategyActionStyle;
  final String name;
  final String subtitle;
  final String? meta;
  final SyncStatusViewModel? syncStatus;
  final String trailing;
  final String strategyTrailing;
  final String? secondaryTrailing;
  final DataSourceConnectionAction? secondaryAction;
  final ProfileDataSourceActionStyle? secondaryActionStyle;
  final Color statusColor;
  final bool active;
  final bool actionEnabled;
  final bool strategyActionEnabled;
  final bool pulsing;
  final bool muted;

  const ProfileDataSourceViewModel({
    required this.kind,
    required this.action,
    required this.strategyAction,
    required this.actionStyle,
    required this.strategyActionStyle,
    required this.name,
    required this.subtitle,
    required this.meta,
    this.syncStatus,
    required this.trailing,
    required this.strategyTrailing,
    this.secondaryTrailing,
    this.secondaryAction,
    this.secondaryActionStyle,
    required this.statusColor,
    required this.active,
    required this.actionEnabled,
    required this.strategyActionEnabled,
    required this.pulsing,
    required this.muted,
  });
}

enum ProfileDataSourceActionStyle {
  primary,
  secondary,
  warning,
  destructive,
  disabled,
}

class ProfileTargetRangeViewModel {
  final IconData icon;
  final String label;
  final String subtitle;
  final String valueLabel;

  const ProfileTargetRangeViewModel({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.valueLabel,
  });
}
