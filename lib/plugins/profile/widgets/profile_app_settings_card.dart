import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class ProfileAppSettingsCard extends StatelessWidget {
  final String summary;
  final VoidCallback onTap;

  const ProfileAppSettingsCard({
    super.key,
    required this.summary,
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
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
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
              child: const Icon(
                Icons.settings_rounded,
                color: AppColors.green,
                size: 17,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                summary,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.text,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textDim,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
