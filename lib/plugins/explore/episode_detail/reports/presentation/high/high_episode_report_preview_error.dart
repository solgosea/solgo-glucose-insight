import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../../application/i18n/episode_detail_l10n.dart';

class HighEpisodeReportPreviewError extends StatelessWidget {
  final VoidCallback onRetry;

  const HighEpisodeReportPreviewError({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppColors.rose,
              size: 28,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.couldNotBuildReport,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.selectedHighUnavailable,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSoft, height: 1.4),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
