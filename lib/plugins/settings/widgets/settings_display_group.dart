import 'package:flutter/material.dart';

import '../models/settings_view_model.dart';
import 'settings_group.dart';
import 'settings_row.dart';

class SettingsDisplayGroup extends StatelessWidget {
  final SettingsDisplayViewModel viewModel;
  final VoidCallback onPickUnit;

  const SettingsDisplayGroup({
    super.key,
    required this.viewModel,
    required this.onPickUnit,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      children: [SettingsRow(row: viewModel.unitRow, onTap: onPickUnit)],
    );
  }
}
