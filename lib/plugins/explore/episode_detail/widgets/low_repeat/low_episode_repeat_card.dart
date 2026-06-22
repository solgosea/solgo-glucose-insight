import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';
import '../repeat/episode_repeat_chart_card.dart';

class LowEpisodeRepeatCard extends StatelessWidget {
  final LowEpisodeRepeatViewModel viewModel;

  const LowEpisodeRepeatCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return EpisodeRepeatChartCard(
      index: '08',
      title: l10n.repeatPattern,
      trailing: viewModel.windowLabel,
      summaryStat: viewModel.summaryStat,
      summaryLabel: viewModel.summaryLabel,
      clusterTitle: viewModel.clusterTitle,
      clusterBody: viewModel.clusterBody,
      dayMarks: viewModel.dayMarks,
      timeBlocks: viewModel.timeBlocks,
      takeaway: viewModel.takeaway,
      cardColor: LowEpisodeStyle.panel,
      panelColor: LowEpisodeStyle.panel2,
      borderColor: LowEpisodeStyle.line,
      accentColor: LowEpisodeStyle.blue,
      hitColor: LowEpisodeStyle.blue,
      strongColor: LowEpisodeStyle.blue,
      currentColor: LowEpisodeStyle.cyan,
      secondaryColor: AppColors.amber,
      textColor: LowEpisodeStyle.text,
      softColor: LowEpisodeStyle.soft,
      mutedColor: LowEpisodeStyle.muted,
    );
  }
}
