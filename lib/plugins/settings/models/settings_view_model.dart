import 'package:flutter/material.dart';

class SettingsViewModel {
  final SettingsDisplayViewModel display;
  final SettingsGroupViewModel sync;
  final SettingsStorageViewModel storage;
  final SettingsGroupViewModel storageActions;
  final SettingsDangerViewModel danger;
  final SettingsAboutViewModel about;
  final bool saving;

  const SettingsViewModel({
    required this.display,
    required this.sync,
    required this.storage,
    required this.storageActions,
    required this.danger,
    required this.about,
    required this.saving,
  });
}

class SettingsDisplayViewModel {
  final SettingsRowViewModel unitRow;

  const SettingsDisplayViewModel({
    required this.unitRow,
  });
}

class SettingsStorageViewModel {
  final String title;
  final String usedLabel;
  final String leftLabel;
  final String coveredLabel;
  final String maxLabel;
  final String retentionSummary;
  final double fillRatio;

  const SettingsStorageViewModel({
    required this.title,
    required this.usedLabel,
    required this.leftLabel,
    required this.coveredLabel,
    required this.maxLabel,
    required this.retentionSummary,
    required this.fillRatio,
  });
}

class SettingsGroupViewModel {
  final List<SettingsRowViewModel> rows;

  const SettingsGroupViewModel({
    required this.rows,
  });
}

class SettingsRowViewModel {
  final IconData icon;
  final String label;
  final String? subtitle;
  final String? valueLabel;
  final bool chevron;
  final SettingsAction action;

  const SettingsRowViewModel({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.valueLabel,
    required this.chevron,
    required this.action,
  });
}

class SettingsDangerViewModel {
  final String title;
  final String subtitle;

  const SettingsDangerViewModel({
    required this.title,
    required this.subtitle,
  });
}

class SettingsAboutViewModel {
  final String title;
  final List<String> links;

  const SettingsAboutViewModel({
    required this.title,
    required this.links,
  });
}

enum SettingsAction {
  none,
  pickLanguage,
  pickUnit,
  pickInitialSyncWindow,
  exportCsv,
  clearAllData,
}
