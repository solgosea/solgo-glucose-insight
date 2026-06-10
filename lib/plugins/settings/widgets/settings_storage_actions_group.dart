import 'package:flutter/material.dart';

import '../models/settings_view_model.dart';
import 'settings_group.dart';
import 'settings_row.dart';

class SettingsStorageActionsGroup extends StatelessWidget {
  final SettingsGroupViewModel viewModel;
  final VoidCallback onExportCsv;
  final VoidCallback? onPickInitialSyncWindow;

  const SettingsStorageActionsGroup({
    super.key,
    required this.viewModel,
    required this.onExportCsv,
    this.onPickInitialSyncWindow,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      children: [
        for (final row in viewModel.rows)
          SettingsRow(row: row, onTap: _tapFor(row.action)),
      ],
    );
  }

  VoidCallback? _tapFor(SettingsAction action) {
    return switch (action) {
      SettingsAction.pickInitialSyncWindow => onPickInitialSyncWindow,
      SettingsAction.exportCsv => onExportCsv,
      _ => null,
    };
  }
}
