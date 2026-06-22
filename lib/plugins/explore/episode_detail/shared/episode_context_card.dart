import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../application/i18n/episode_detail_l10n.dart';

/// One row of the CGM Context card.
class EpisodeContextRow {
  final String icon; // emoji
  final String timeWindow; // e.g. "05:50–06:50"
  final String description;
  final String contextTag; // e.g. "~1h before"

  const EpisodeContextRow({
    required this.icon,
    required this.timeWindow,
    required this.description,
    required this.contextTag,
  });
}

class EpisodeContextCard extends StatelessWidget {
  final List<EpisodeContextRow> rows;

  const EpisodeContextCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.episodeDetailL10n.cgmContextBeforeEpisode.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppColors.textDim,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < rows.length; i++)
            _Row(row: rows[i], isLast: i == rows.length - 1),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final EpisodeContextRow row;
  final bool isLast;
  const _Row({required this.row, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 10),
            child:
                Text(row.icon, style: const TextStyle(fontSize: 15, height: 1)),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSoft,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '${row.timeWindow} ',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: AppColors.textDim,
                    ),
                  ),
                  TextSpan(text: row.description),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              row.contextTag,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textDim,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
