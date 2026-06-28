import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import '../models/history_view_model.dart';

class HistoryEpisodeRow extends StatelessWidget {
  final HistoryEpisodeCalloutViewModel episode;
  final VoidCallback onTap;

  const HistoryEpisodeRow({
    super.key,
    required this.episode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                left: 0,
                right: null,
                child: Container(width: 3, color: episode.color),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 9, 10, 9),
                child: Row(
                  children: [
                    _EpisodeMark(episode: episode),
                    const SizedBox(width: 9),
                    SizedBox(
                      width: 42,
                      child: Text(
                        episode.timeLabel,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            episode.meta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDim,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _EpisodeValue(episode: episode),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppColors.textDim,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EpisodeMark extends StatelessWidget {
  final HistoryEpisodeCalloutViewModel episode;

  const _EpisodeMark({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: episode.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: episode.color.withValues(alpha: 0.25)),
      ),
      child: Icon(episode.icon, size: 16, color: episode.color),
    );
  }
}

class _EpisodeValue extends StatelessWidget {
  final HistoryEpisodeCalloutViewModel episode;

  const _EpisodeValue({required this.episode});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            episode.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w900,
              color: episode.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            episode.unit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: AppColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}
