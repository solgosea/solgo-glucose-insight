import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/settings_view_model.dart';

class SettingsRow extends StatelessWidget {
  final SettingsRowViewModel row;
  final VoidCallback? onTap;

  const SettingsRow({super.key, required this.row, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgCard2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(row.icon, color: AppColors.green, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
                if (row.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    row.subtitle!,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (row.valueLabel != null) _ValuePill(text: row.valueLabel!),
          if (row.chevron) ...[
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textDim,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return body;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: body,
    );
  }
}

class _ValuePill extends StatelessWidget {
  final String text;

  const _ValuePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.04),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
          color: AppColors.textSoft,
        ),
      ),
    );
  }
}
