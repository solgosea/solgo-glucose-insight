import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';

import '../models/settings_view_model.dart';
import 'settings_header.dart';
import 'settings_render_scope.dart';
import 'settings_slot_host.dart';

class SettingsBody extends StatelessWidget {
  final SettingsViewModel viewModel;
  final VoidCallback onBack;
  final VoidCallback onPickUnit;
  final VoidCallback onPickLanguage;
  final VoidCallback onPickInitialSyncWindow;
  final VoidCallback onExportCsv;
  final VoidCallback onClearAllData;

  const SettingsBody({
    super.key,
    required this.viewModel,
    required this.onBack,
    required this.onPickUnit,
    required this.onPickLanguage,
    required this.onPickInitialSyncWindow,
    required this.onExportCsv,
    required this.onClearAllData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsHeader(onBack: onBack),
              SettingsRenderScope(
                viewModel: viewModel,
                onPickUnit: onPickUnit,
                onPickLanguage: onPickLanguage,
                onPickInitialSyncWindow: onPickInitialSyncWindow,
                onExportCsv: onExportCsv,
                onClearAllData: onClearAllData,
                child: SettingsSlotHost(labelBuilder: _sectionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String title) {
    return SectionLabel(title);
  }
}
