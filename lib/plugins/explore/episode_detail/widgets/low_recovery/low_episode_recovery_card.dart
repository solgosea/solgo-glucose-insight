import 'package:flutter/material.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';
import '../shared/episode_section_label.dart';

class LowEpisodeRecoveryCard extends StatelessWidget {
  final LowEpisodeRecoveryViewModel viewModel;

  const LowEpisodeRecoveryCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EpisodeSectionLabel(
          index: '06',
          title: l10n.recoveryQuality,
          trailing: l10n.returnedInRange,
          accent: LowEpisodeStyle.blue,
        ),
        EpisodeSectionCard(
          color: LowEpisodeStyle.panel,
          borderColor: LowEpisodeStyle.line,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 84,
                height: 84,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: viewModel.qualityColor.withOpacity(0.72),
                    width: 7,
                  ),
                  color: viewModel.qualityColor.withOpacity(0.08),
                ),
                child: Text(
                  viewModel.recoveryMinutesText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: viewModel.qualityColor,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.qualityLabel,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: LowEpisodeStyle.text,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      viewModel.recoveryTimeText == l10n.notVisible ||
                              viewModel.recoveryTimeText == 'Not visible'
                          ? l10n.recoveryNotVisible
                          : l10n.recoveredAt(viewModel.recoveryTimeText),
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        color: LowEpisodeStyle.muted,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      viewModel.note,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: LowEpisodeStyle.soft,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
