import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../foundation/theme/app_colors.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_runtime_state.dart';
import '../../../plugin_platform/contracts/plugin_runtime_status.dart';
import '../application/i18n/explore_l10n.dart';

class ExploreFeaturedSection extends StatelessWidget {
  final ExplorePluginEntry? reportEntry;
  final PluginRuntimeState? reportState;

  const ExploreFeaturedSection({
    super.key,
    this.reportEntry,
    this.reportState,
  });

  @override
  Widget build(BuildContext context) {
    if (reportEntry == null) return const SizedBox();
    final l10n = context.exploreL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Text(
            l10n.featuredPlugins,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.6,
              color: AppColors.textDim,
            ),
          ),
        ),
        if (reportEntry != null)
          _FeaturedPluginCard(
            entry: reportEntry!,
            state: reportState,
            eyebrow: l10n.featuredReportEyebrow,
            badge: l10n.featuredReportBadge,
            title: l10n.featuredReportTitle,
            body: l10n.featuredReportBody,
            cta: '',
            color: AppColors.green,
            icon: Icons.description_rounded,
            gradientEnd: AppColors.amber,
            showFooter: false,
          ),
      ],
    );
  }
}

class _FeaturedPluginCard extends StatelessWidget {
  final ExplorePluginEntry entry;
  final PluginRuntimeState? state;
  final String eyebrow;
  final String badge;
  final String title;
  final String body;
  final String cta;
  final Color color;
  final Color gradientEnd;
  final IconData icon;
  final bool showFooter;

  const _FeaturedPluginCard({
    required this.entry,
    required this.state,
    required this.eyebrow,
    required this.badge,
    required this.title,
    required this.body,
    required this.cta,
    required this.color,
    required this.gradientEnd,
    required this.icon,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = state?.enabled ?? true;
    final effectiveColor = enabled ? color : AppColors.textDim;
    return GestureDetector(
      onTap: enabled ? () => context.push(entry.route) : null,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        padding: const EdgeInsets.fromLTRB(18, 16, 16, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: enabled ? color.withOpacity(0.3) : AppColors.border,
            width: 1.5,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(enabled ? 0.12 : 0.04),
              gradientEnd.withOpacity(enabled ? 0.06 : 0.03),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -34,
              right: -30,
              child: Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(enabled ? 0.1 : 0.04),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: effectiveColor.withOpacity(0.3),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            effectiveColor.withOpacity(0.2),
                            gradientEnd.withOpacity(enabled ? 0.1 : 0.04),
                          ],
                        ),
                      ),
                      child: Icon(icon, color: effectiveColor, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eyebrow,
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: effectiveColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                height: 1.25,
                                fontWeight: FontWeight.w800,
                                color: enabled
                                    ? AppColors.text
                                    : AppColors.textDim,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              state?.reason ?? body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.5,
                                height: 1.45,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (showFooter) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (enabled)
                        Text(
                          cta,
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: effectiveColor,
                          ),
                        )
                      else
                        _DisabledPill(label: _disabledLabel(context, state)),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: enabled ? AppColors.textDim : AppColors.border,
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                badge,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: effectiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _disabledLabel(BuildContext context, PluginRuntimeState? state) {
    final l10n = context.exploreL10n;
    return switch (state?.status) {
      PluginRuntimeStatus.noData => l10n.runtimeNoData,
      PluginRuntimeStatus.missingSource => l10n.runtimeNoSource,
      PluginRuntimeStatus.disabled => l10n.runtimeDisabled,
      PluginRuntimeStatus.hidden => l10n.runtimeHidden,
      PluginRuntimeStatus.available || null => l10n.runtimeUnavailable,
    };
  }
}

class _DisabledPill extends StatelessWidget {
  final String label;

  const _DisabledPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgCard2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.textDim,
        ),
      ),
    );
  }
}
