import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/placement/section_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry.dart';
import 'package:smart_xdrip/plugin_platform/runtime/plugin_capability_context_factory.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';

import '../models/profile_view_model.dart';
import 'profile_app_settings_card.dart';
import 'profile_data_source_card.dart';
import 'profile_header_card.dart';
import 'profile_stats_strip.dart';
import 'profile_target_range_card.dart';

class ProfileBody extends StatelessWidget {
  final ProfileViewModel viewModel;
  final VoidCallback onSettingsTap;
  final ValueChanged<ProfileDataSourceViewModel> onSourceAction;
  final ValueChanged<ProfileDataSourceViewModel> onSourceStrategyAction;
  final ValueChanged<ProfileDataSourceViewModel> onSourceSecondaryAction;
  final VoidCallback onTargetRangeTap;

  const ProfileBody({
    super.key,
    required this.viewModel,
    required this.onSettingsTap,
    required this.onSourceAction,
    required this.onSourceStrategyAction,
    required this.onSourceSecondaryAction,
    required this.onTargetRangeTap,
  });

  @override
  Widget build(BuildContext context) {
    final pluginContext = PluginCapabilityContextFactory.current().create();
    final registry = context.read<PluginRegistry>();
    final sections = SectionPluginResolver(
      registry: registry,
      placement: PluginPlacement.profileSection,
    ).resolveWithState(context: pluginContext);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeaderCard(viewModel: viewModel.header),
              ProfileStatsStrip(stats: viewModel.stats),
              for (final section in sections)
                ..._sectionWidgets(section.entry.section),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _sectionWidgets(String section) {
    return switch (section) {
      'Data Source' => [
        const SectionLabel('Data Source'),
        ProfileDataSourceCard(
          sources: viewModel.dataSources,
          onSourceAction: onSourceAction,
          onSourceStrategyAction: onSourceStrategyAction,
          onSourceSecondaryAction: onSourceSecondaryAction,
        ),
      ],
      'Target Range' => [
        const SectionLabel('Target Range'),
        ProfileTargetRangeCard(
          ranges: viewModel.targetRanges,
          onTap: onTargetRangeTap,
        ),
      ],
      'App Settings' => [
        const SectionLabel('App Settings'),
        ProfileAppSettingsCard(
          summary: viewModel.appSettingsSummary,
          onTap: onSettingsTap,
        ),
      ],
      _ => const <Widget>[],
    };
  }
}
