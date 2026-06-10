import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model_mapper.dart';

import '../analyzers/profile_summary_analyzer.dart';
import '../models/profile_analysis_result.dart';
import '../models/profile_view_model.dart';

class ProfileViewModelMapper {
  final ProfileSummaryAnalyzer analyzer;
  final GlucoseUnitFormatService glucoseFormatter;
  final SyncStatusViewModelMapper syncStatusMapper;

  const ProfileViewModelMapper({
    this.analyzer = const ProfileSummaryAnalyzer(),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.syncStatusMapper = const SyncStatusViewModelMapper(),
  });

  ProfileViewModel map({
    required AnalysisFacade facade,
    required AppSettings settings,
    required SyncStatusSnapshot syncStatus,
    required List<DataSourceConnectionSnapshot> dataSourceSnapshots,
  }) {
    final result = analyzer.analyze(facade: facade);
    final average14d = glucoseFormatter.value(result.average14d, settings.unit);
    return ProfileViewModel(
      header: ProfileHeaderViewModel(
        title: 'My Profile',
        primaryBadge:
            result.latestReadingAt == null ? 'Waiting for data' : 'Data ready',
      ),
      stats: [
        ProfileStatViewModel(
          value: result.tir14d.toStringAsFixed(0),
          unit: '%',
          label: 'TIR 14d',
          valueColor: _tirColor(result.tir14d),
        ),
        ProfileStatViewModel(
          value: average14d.valueLabel,
          unit: average14d.unitLabel,
          label: 'Avg 14d',
          valueColor: AppColors.text,
        ),
        ProfileStatViewModel(
          value: result.cv14d.toStringAsFixed(0),
          unit: '%',
          label: 'CV 14d',
          valueColor: _cvColor(result.cv14d),
        ),
      ],
      dataSources: _dataSources(dataSourceSnapshots, syncStatus: syncStatus),
      targetRanges:
          result.targetRanges
              .map((range) => _targetRange(range, settings.unit))
              .toList(),
      appSettingsSummary: 'Settings',
    );
  }

  List<ProfileDataSourceViewModel> _dataSources(
    List<DataSourceConnectionSnapshot> snapshots, {
    required SyncStatusSnapshot syncStatus,
  }) {
    return snapshots.map((snapshot) {
      return ProfileDataSourceViewModel(
        kind: snapshot.kind,
        action: snapshot.action,
        strategyAction: snapshot.strategyAction,
        actionStyle: _sourceActionStyle(snapshot.action),
        strategyActionStyle: _strategyActionStyle(snapshot.strategyAction),
        name: snapshot.title,
        subtitle: snapshot.subtitle,
        meta: _sourceMeta(snapshot),
        syncStatus: _sourceSyncStatus(snapshot, syncStatus: syncStatus),
        trailing: snapshot.trailing,
        strategyTrailing: snapshot.strategyTrailing,
        secondaryTrailing:
            snapshot.kind == DataSourceKind.nightscout ? 'Edit' : null,
        secondaryAction:
            snapshot.kind == DataSourceKind.nightscout
                ? DataSourceConnectionAction.configure
                : null,
        secondaryActionStyle:
            snapshot.kind == DataSourceKind.nightscout
                ? ProfileDataSourceActionStyle.warning
                : null,
        statusColor: _sourceStatusColor(snapshot),
        active: snapshot.active,
        actionEnabled: snapshot.action != DataSourceConnectionAction.none,
        strategyActionEnabled:
            snapshot.strategyAction != DataSourceSyncStrategyAction.none,
        pulsing: snapshot.status == DataSourceConnectionStatus.syncing,
        muted: _sourceMuted(snapshot),
      );
    }).toList();
  }

  ProfileTargetRangeViewModel _targetRange(
    ProfileTargetRange range,
    GlucoseUnit unit,
  ) {
    return ProfileTargetRangeViewModel(
      icon: switch (range.kind) {
        ProfileTargetRangeKind.target => Icons.stacked_line_chart_rounded,
        ProfileTargetRangeKind.low => Icons.trending_down_rounded,
        ProfileTargetRangeKind.high => Icons.trending_up_rounded,
        ProfileTargetRangeKind.veryHigh => Icons.warning_amber_rounded,
      },
      label: range.label,
      subtitle: range.description,
      valueLabel:
          range.upperValue == null
              ? glucoseFormatter.value(range.value, unit).fullLabel
              : glucoseFormatter
                  .range(range.value, range.upperValue!, unit)
                  .fullLabel,
    );
  }

  Color _tirColor(double value) {
    return value >= 70 ? AppColors.text : AppColors.amber;
  }

  Color _cvColor(double value) {
    if (value <= 30) return AppColors.green;
    if (value <= 36) return AppColors.text;
    return AppColors.amber;
  }

  Color _sourceStatusColor(DataSourceConnectionSnapshot snapshot) {
    return switch (snapshot.status) {
      DataSourceConnectionStatus.detected ||
      DataSourceConnectionStatus.syncing => AppColors.green,
      DataSourceConnectionStatus.connected ||
      DataSourceConnectionStatus.configured => AppColors.amber,
      DataSourceConnectionStatus.failed => AppColors.rose,
      _ => AppColors.textDim,
    };
  }

  bool _sourceMuted(DataSourceConnectionSnapshot snapshot) {
    return switch (snapshot.status) {
      DataSourceConnectionStatus.notDetected ||
      DataSourceConnectionStatus.notConfigured ||
      DataSourceConnectionStatus.unsupported => true,
      _ => false,
    };
  }

  ProfileDataSourceActionStyle _sourceActionStyle(
    DataSourceConnectionAction action,
  ) {
    return switch (action) {
      DataSourceConnectionAction.connect ||
      DataSourceConnectionAction
          .configure => ProfileDataSourceActionStyle.primary,
      DataSourceConnectionAction.use => ProfileDataSourceActionStyle.secondary,
      DataSourceConnectionAction.sync => ProfileDataSourceActionStyle.primary,
      DataSourceConnectionAction.detect => ProfileDataSourceActionStyle.warning,
      DataSourceConnectionAction.disconnect =>
        ProfileDataSourceActionStyle.destructive,
      DataSourceConnectionAction.none => ProfileDataSourceActionStyle.disabled,
    };
  }

  ProfileDataSourceActionStyle _strategyActionStyle(
    DataSourceSyncStrategyAction action,
  ) {
    return switch (action) {
      DataSourceSyncStrategyAction.enable =>
        ProfileDataSourceActionStyle.primary,
      DataSourceSyncStrategyAction.syncNow =>
        ProfileDataSourceActionStyle.secondary,
      DataSourceSyncStrategyAction.disable =>
        ProfileDataSourceActionStyle.destructive,
      DataSourceSyncStrategyAction.none =>
        ProfileDataSourceActionStyle.disabled,
    };
  }

  String? _sourceMeta(DataSourceConnectionSnapshot snapshot) {
    final state = snapshot.syncState;
    if (snapshot.active) return null;
    if (!snapshot.active &&
        snapshot.status == DataSourceConnectionStatus.failed) {
      return 'Connection check failed';
    }
    if (!(snapshot.configured || snapshot.detected)) return 'Not configured';
    if (state?.lastError != null) return 'Last sync failed';
    if (state?.lastSuccessAt == null) return 'Waiting for first sync';
    return null;
  }

  SyncStatusViewModel? _sourceSyncStatus(
    DataSourceConnectionSnapshot snapshot, {
    required SyncStatusSnapshot syncStatus,
  }) {
    if (!snapshot.active) return null;
    if (!syncStatus.active) return null;
    if (syncStatus.sourceLabel != snapshot.title &&
        syncStatus.sourceLabel != 'Data sources') {
      return null;
    }
    return syncStatusMapper.map(syncStatus);
  }
}
