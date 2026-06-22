import 'package:flutter/material.dart';

import '../../domain/floating/floating_glance_setup_state.dart';
import '../../application/i18n/glance_l10n.dart';
import '../../l10n/generated/glance_localizations.dart';
import '../styles/glance_theme.dart';

class FloatingGlanceSetupStatus extends StatelessWidget {
  final FloatingGlanceSetupState state;
  final VoidCallback onRequestPermission;
  final VoidCallback onShow;
  final VoidCallback onHide;

  const FloatingGlanceSetupStatus({
    super.key,
    required this.state,
    required this.onRequestPermission,
    required this.onShow,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    final model = _SetupStatusModel.fromState(
      state,
      l10n: context.glanceL10n,
      onRequestPermission: onRequestPermission,
      onShow: onShow,
      onHide: onHide,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: model.color.withOpacity(.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: model.color.withOpacity(.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: model.color.withOpacity(.11),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: model.color.withOpacity(.20)),
                ),
                child: Icon(model.icon, color: model.color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: GlanceTheme.label.copyWith(
                        color: model.color,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.body,
                      style: GlanceTheme.label.copyWith(
                        color: GlanceTheme.soft,
                        fontSize: 11,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: model.action,
              icon: Icon(model.actionIcon, size: 16),
              label: Text(model.actionLabel),
              style: FilledButton.styleFrom(
                backgroundColor: model.actionColor,
                foregroundColor: const Color(0xFF07120D),
                padding: const EdgeInsets.symmetric(vertical: 11),
                textStyle: GlanceTheme.label.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupStatusModel {
  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final IconData actionIcon;
  final Color color;
  final Color actionColor;
  final VoidCallback action;

  const _SetupStatusModel({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.actionIcon,
    required this.color,
    required this.actionColor,
    required this.action,
  });

  factory _SetupStatusModel.fromState(
    FloatingGlanceSetupState state, {
    required GlanceLocalizations l10n,
    required VoidCallback onRequestPermission,
    required VoidCallback onShow,
    required VoidCallback onHide,
  }) {
    return switch (state) {
      FloatingGlanceSetupState.permissionNeeded => _SetupStatusModel(
          icon: Icons.open_in_new_rounded,
          title: l10n.floatingPermissionNeededTitle,
          body: l10n.floatingPermissionNeededBody,
          actionLabel: l10n.floatingPermissionNeededAction,
          actionIcon: Icons.open_in_new_rounded,
          color: GlanceTheme.amber,
          actionColor: GlanceTheme.amber,
          action: onRequestPermission,
        ),
      FloatingGlanceSetupState.permissionGranted => _SetupStatusModel(
          icon: Icons.check_circle_outline_rounded,
          title: l10n.floatingPermissionGrantedTitle,
          body: l10n.floatingPermissionGrantedBody,
          actionLabel: l10n.floatingShowAction,
          actionIcon: Icons.picture_in_picture_alt_rounded,
          color: GlanceTheme.green,
          actionColor: GlanceTheme.green,
          action: onShow,
        ),
      FloatingGlanceSetupState.visible => _SetupStatusModel(
          icon: Icons.visibility_outlined,
          title: l10n.floatingVisibleTitle,
          body: l10n.floatingVisibleBody,
          actionLabel: l10n.floatingHideAction,
          actionIcon: Icons.visibility_off_outlined,
          color: GlanceTheme.green,
          actionColor: GlanceTheme.soft,
          action: onHide,
        ),
      FloatingGlanceSetupState.hidden => _SetupStatusModel(
          icon: Icons.visibility_off_outlined,
          title: l10n.floatingHiddenTitle,
          body: l10n.floatingHiddenBody,
          actionLabel: l10n.floatingShowAction,
          actionIcon: Icons.picture_in_picture_alt_rounded,
          color: GlanceTheme.soft,
          actionColor: GlanceTheme.green,
          action: onShow,
        ),
      FloatingGlanceSetupState.unavailable => _SetupStatusModel(
          icon: Icons.layers_clear_outlined,
          title: l10n.floatingUnavailableTitle,
          body: l10n.floatingUnavailableBody,
          actionLabel: l10n.floatingUnavailableAction,
          actionIcon: Icons.block_rounded,
          color: GlanceTheme.dim,
          actionColor: GlanceTheme.dim,
          action: () {},
        ),
    };
  }
}
