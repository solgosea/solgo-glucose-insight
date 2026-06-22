import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../../application/i18n/episode_detail_l10n.dart';

class HighEpisodeReportPreviewTopBar extends StatelessWidget {
  final bool exporting;
  final VoidCallback onBack;
  final VoidCallback onPrint;
  final VoidCallback onShare;

  const HighEpisodeReportPreviewTopBar({
    super.key,
    required this.exporting,
    required this.onBack,
    required this.onPrint,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Row(
      children: [
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.chevron_left_rounded),
          label: Text(l10n.backToEpisode),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF385748),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: exporting ? null : onShare,
          icon: exporting
              ? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.ios_share_rounded, size: 17),
          label: Text(exporting ? l10n.exporting : l10n.share),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF385748),
            side: const BorderSide(color: Color(0xFFCBD7D0)),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: exporting ? null : onPrint,
          icon: const Icon(Icons.print_rounded, size: 17),
          label: Text(l10n.printSave),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.bg,
            disabledBackgroundColor: AppColors.green.withOpacity(0.35),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}
