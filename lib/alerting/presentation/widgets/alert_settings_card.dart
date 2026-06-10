import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';

class AlertSettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final List<String> details;
  final VoidCallback? onTap;

  const AlertSettingsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onChanged,
    this.details = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.green, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.textSoft,
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    IconButton(
                      tooltip: 'Configure',
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textDim,
                      ),
                    ),
                  Switch.adaptive(
                    value: enabled,
                    activeColor: AppColors.green,
                    onChanged: onChanged,
                  ),
                ],
              ),
              if (details.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final detail in details)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard2,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          detail,
                          style: const TextStyle(
                            color: AppColors.textSoft,
                            fontSize: 10,
                            fontFamily: 'JetBrainsMono',
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
