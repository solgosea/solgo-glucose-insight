import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/settings_view_model.dart';

class SettingsDangerCard extends StatelessWidget {
  final SettingsDangerViewModel viewModel;
  final VoidCallback onTap;

  const SettingsDangerCard({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        decoration: BoxDecoration(
          color: AppColors.rose.withOpacity(0.04),
          border: Border.all(color: AppColors.rose.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewModel.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.rose,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    viewModel.subtitle,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textDim,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.rose,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
