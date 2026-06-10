import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/alerting/presentation/widgets/alert_settings_entry_card.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/placement/section_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry.dart';
import 'package:smart_xdrip/plugin_platform/runtime/plugin_capability_context_factory.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';

import '../models/settings_view_model.dart';
import 'settings_about_block.dart';
import 'settings_danger_card.dart';
import 'settings_display_group.dart';
import 'settings_header.dart';
import 'settings_storage_actions_group.dart';
import 'settings_storage_card.dart';

class SettingsBody extends StatelessWidget {
  final SettingsViewModel viewModel;
  final VoidCallback onBack;
  final VoidCallback onPickUnit;
  final VoidCallback onPickInitialSyncWindow;
  final VoidCallback onExportCsv;
  final VoidCallback onClearAllData;

  const SettingsBody({
    super.key,
    required this.viewModel,
    required this.onBack,
    required this.onPickUnit,
    required this.onPickInitialSyncWindow,
    required this.onExportCsv,
    required this.onClearAllData,
  });

  @override
  Widget build(BuildContext context) {
    final pluginContext = PluginCapabilityContextFactory.current().create();
    final registry = context.read<PluginRegistry>();
    final sections = SectionPluginResolver(
      registry: registry,
      placement: PluginPlacement.settingsSection,
    ).resolveWithState(context: pluginContext);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsHeader(onBack: onBack),
              for (final section in sections)
                ..._buildSection(context, section.entry),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSection(BuildContext context, SectionPluginEntry section) {
    return switch (section.section) {
      'Display' => [
        const SectionLabel('Display'),
        SettingsDisplayGroup(
          viewModel: viewModel.display,
          onPickUnit: onPickUnit,
        ),
      ],
      'Sync Settings' => [
        const SectionLabel('Sync Settings'),
        SettingsStorageActionsGroup(
          viewModel: viewModel.sync,
          onPickInitialSyncWindow: onPickInitialSyncWindow,
          onExportCsv: onExportCsv,
        ),
      ],
      'Data Storage' => [
        const SectionLabel('Data Storage'),
        SettingsStorageCard(viewModel: viewModel.storage),
      ],
      'Alerts' => [
        const SectionLabel('Alerts'),
        const AlertSettingsEntryCard(),
      ],
      'Data Export' => [
        const SectionLabel('Data Export'),
        SettingsStorageActionsGroup(
          viewModel: viewModel.storageActions,
          onExportCsv: onExportCsv,
        ),
      ],
      'Danger Zone' => [
        const SectionLabel('Danger Zone'),
        SettingsDangerCard(viewModel: viewModel.danger, onTap: onClearAllData),
      ],
      'About' => [SettingsAboutBlock(viewModel: viewModel.about)],
      _ => const [],
    };
  }
}
