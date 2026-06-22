import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_render_context.dart';

import '../../application/i18n/profile_l10n.dart';
import '../../application/profile_host_services.dart';
import '../../application/profile_settings_actions.dart';
import '../target_range_ruler_sheet.dart';
import '../target_range_value_policy.dart';
import 'target_range_profile_card.dart';
import 'target_range_profile_view_model_mapper.dart';

class TargetRangeProfileSection extends StatelessWidget {
  final PluginRenderContext renderContext;
  final TargetRangeProfileViewModelMapper mapper;

  const TargetRangeProfileSection({
    super.key,
    required this.renderContext,
    this.mapper = const TargetRangeProfileViewModelMapper(),
  });

  @override
  Widget build(BuildContext context) {
    final actions = renderContext.services.get<ProfileSettingsActions>();
    final hostServices = renderContext.services.get<ProfileHostServices>();
    return AnimatedBuilder(
      animation: hostServices.changeSignal,
      builder: (context, _) {
        final settings = actions.settingsProvider();
        return TargetRangeProfileCard(
          viewModel: mapper.map(settings, l10n: context.profileL10n),
          onTap: () => _editTargetRange(context, actions),
        );
      },
    );
  }

  Future<void> _editTargetRange(
    BuildContext context,
    ProfileSettingsActions actions,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.profileL10n;
    final draft = await showModalBottomSheet<TargetRangeDraft>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          TargetRangeRulerSheet(settings: actions.settingsProvider()),
    );
    if (draft == null) return;
    await actions.updateTargetRange(draft);
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bgCard2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          l10n.targetRangeUpdated,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}
