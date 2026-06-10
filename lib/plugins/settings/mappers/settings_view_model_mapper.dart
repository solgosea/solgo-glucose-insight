import 'package:flutter/material.dart';

import 'package:smart_xdrip/domain/entities/app_settings.dart';
import '../models/settings_analysis_result.dart';
import '../models/settings_view_model.dart';

class SettingsViewModelMapper {
  const SettingsViewModelMapper();

  SettingsViewModel map({
    required SettingsAnalysisResult analysis,
    required bool saving,
  }) {
    final settings = analysis.settings;
    return SettingsViewModel(
      display: SettingsDisplayViewModel(
        unitRow: SettingsRowViewModel(
          icon: Icons.show_chart_rounded,
          label: 'Units',
          subtitle: 'Blood glucose unit',
          valueLabel: _unitLabel(settings.unit),
          chevron: true,
          action: SettingsAction.pickUnit,
        ),
      ),
      sync: SettingsGroupViewModel(
        rows: [
          SettingsRowViewModel(
            icon: Icons.sync_rounded,
            label: 'Initial sync window',
            subtitle: 'Used when connecting a new source',
            valueLabel: '${settings.initialSyncDays} days',
            chevron: true,
            action: SettingsAction.pickInitialSyncWindow,
          ),
        ],
      ),
      storage: SettingsStorageViewModel(
        title: 'Local storage',
        usedLabel: '${_formatBytes(analysis.dbBytes)} used',
        leftLabel: '0',
        coveredLabel: '${analysis.daysCovered} days',
        maxLabel: '${settings.retentionDays} days max',
        retentionSummary:
            'Data retention: ${settings.retentionDays} days - No data leaves this device',
        fillRatio: _fillRatio(
          daysCovered: analysis.daysCovered,
          retentionDays: settings.retentionDays,
        ),
      ),
      storageActions: SettingsGroupViewModel(
        rows: [
          SettingsRowViewModel(
            icon: Icons.storage_rounded,
            label: 'Retention period',
            subtitle: 'Auto-trims older readings',
            valueLabel: '${settings.retentionDays} days',
            chevron: true,
            action: SettingsAction.none,
          ),
          const SettingsRowViewModel(
            icon: Icons.file_download_outlined,
            label: 'Export data',
            subtitle: 'Save readings as CSV',
            valueLabel: null,
            chevron: true,
            action: SettingsAction.exportCsv,
          ),
        ],
      ),
      danger: const SettingsDangerViewModel(
        title: 'Clear all data',
        subtitle: 'Permanently removes all stored readings',
      ),
      about: const SettingsAboutViewModel(
        title: 'Smart xDrip v0.1.0 - Local-only - No account required',
        links: ['Privacy', 'Open source'],
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

  double _fillRatio({required int daysCovered, required int retentionDays}) {
    if (retentionDays <= 0) return 0;
    return (daysCovered / retentionDays).clamp(0.0, 1.0).toDouble();
  }
}
