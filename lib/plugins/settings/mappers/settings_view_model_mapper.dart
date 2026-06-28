import 'package:flutter/material.dart';

import 'package:smart_xdrip/core/app_metadata.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import '../application/i18n/settings_l10n_resolver.dart';
import '../l10n/generated/settings_localizations.dart';
import '../models/settings_analysis_result.dart';
import '../models/settings_view_model.dart';

class SettingsViewModelMapper {
  final SettingsLocalizations l10n;

  SettingsViewModelMapper({
    SettingsLocalizations? l10n,
  }) : l10n = l10n ?? SettingsL10nResolver.fallback;

  SettingsViewModel map({
    required SettingsAnalysisResult analysis,
    required bool saving,
    AppMetadata appMetadata = AppMetadata.fallback,
  }) {
    final settings = analysis.settings;
    return SettingsViewModel(
      display: SettingsDisplayViewModel(
        unitRow: SettingsRowViewModel(
          icon: Icons.show_chart_rounded,
          label: l10n.settingsUnitsLabel,
          subtitle: l10n.settingsBloodGlucoseUnitSubtitle,
          valueLabel: _unitLabel(settings.unit),
          chevron: true,
          action: SettingsAction.pickUnit,
        ),
      ),
      sync: SettingsGroupViewModel(
        rows: [
          SettingsRowViewModel(
            icon: Icons.sync_rounded,
            label: l10n.settingsSyncWindowLabel,
            subtitle: l10n.settingsSyncWindowSubtitle,
            valueLabel: l10n.settingsSyncWindowValue(
              settings.initialSyncDays,
              settings.syncIntervalMinutes,
            ),
            chevron: true,
            action: SettingsAction.pickInitialSyncWindow,
          ),
        ],
      ),
      storage: SettingsStorageViewModel(
        title: l10n.settingsLocalStorageTitle,
        usedLabel:
            '${_formatBytes(analysis.dbBytes)} ${l10n.settingsStorageUsed}',
        leftLabel: '0',
        coveredLabel: '${analysis.daysCovered} ${l10n.settingsDaysCovered}',
        maxLabel: '${settings.retentionDays} ${l10n.settingsDaysMax}',
        retentionSummary:
            '${l10n.settingsRetentionSummaryPrefix} ${settings.retentionDays} '
            '${l10n.settingsDaysSuffix} - ${l10n.settingsRetentionSummarySuffix}',
        fillRatio: _fillRatio(
          daysCovered: analysis.daysCovered,
          retentionDays: settings.retentionDays,
        ),
      ),
      storageActions: SettingsGroupViewModel(
        rows: [
          SettingsRowViewModel(
            icon: Icons.storage_rounded,
            label: l10n.settingsRetentionPeriodLabel,
            subtitle: l10n.settingsRetentionPeriodSubtitle,
            valueLabel: '${settings.retentionDays} ${l10n.settingsDaysSuffix}',
            chevron: true,
            action: SettingsAction.none,
          ),
          SettingsRowViewModel(
            icon: Icons.file_download_outlined,
            label: l10n.settingsExportDataLabel,
            subtitle: l10n.settingsExportDataSubtitle,
            valueLabel: null,
            chevron: true,
            action: SettingsAction.exportCsv,
          ),
        ],
      ),
      danger: SettingsDangerViewModel(
        title: l10n.settingsClearAllDataTitle,
        subtitle: l10n.settingsClearAllDataSubtitle,
      ),
      about: SettingsAboutViewModel(
        title: appMetadata.aboutTitle,
        links: [l10n.settingsPrivacyLink, l10n.settingsOpenSourceLink],
      ),
      saving: saving,
    );
  }

  String _unitLabel(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 'mmol/L',
      GlucoseUnit.mgDl => 'mg/dL',
    };
  }

  String _formatBytes(int? bytes) {
    if (bytes == null) return '-';
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  double _fillRatio({
    required int daysCovered,
    required int retentionDays,
  }) {
    if (retentionDays <= 0) return 0;
    return (daysCovered / retentionDays).clamp(0.0, 1.0).toDouble();
  }
}
