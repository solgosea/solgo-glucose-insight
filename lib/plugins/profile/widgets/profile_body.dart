import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';

import '../application/i18n/profile_l10n.dart';
import '../models/profile_view_model.dart';
import 'profile_app_settings_card.dart';
import 'profile_header_card.dart';
import 'profile_slot_host.dart';
import 'profile_stats_strip.dart';

class ProfileBody extends StatelessWidget {
  final ProfileViewModel viewModel;
  final VoidCallback onSettingsTap;

  const ProfileBody({
    super.key,
    required this.viewModel,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.profileL10n;
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
              const ProfileSectionSlotHost(),
              SectionLabel(l10n.profileSectionAppSettings),
              ProfileAppSettingsCard(
                summary: viewModel.appSettingsSummary,
                onTap: onSettingsTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
