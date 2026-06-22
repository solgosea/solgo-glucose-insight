import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../foundation/theme/app_colors.dart';
import '../../application/i18n/alerting_l10n.dart';

class AlertSettingsEntryCard extends StatelessWidget {
  const AlertSettingsEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.alertingL10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: GestureDetector(
        onTap: () => context.push('/alerting/settings'),
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.rose.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.rose,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.alertSettingsEntryTitle,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.alertSettingsEntrySubtitle,
                        style: const TextStyle(
                          color: AppColors.textSoft,
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textDim),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
