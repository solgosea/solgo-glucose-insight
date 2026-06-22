import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../application/i18n/episode_detail_l10n.dart';
import '../../models/episode_detail_view_model.dart';
import '../repeat/episode_repeat_chart_card.dart';

class HighEpisodeRepeatCard extends StatelessWidget {
  final HighEpisodeRepeatViewModel viewModel;

  const HighEpisodeRepeatCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.episodeDetailL10n;
    return EpisodeRepeatChartCard(
      index: '07',
      title: l10n.repeatPattern,
      trailing: viewModel.windowLabel,
      summaryStat: viewModel.summaryStat,
      summaryLabel: viewModel.summaryLabel,
      clusterTitle: viewModel.clusterTitle,
      clusterBody: viewModel.clusterBody,
      dayMarks: viewModel.dayMarks,
      timeBlocks: viewModel.timeBlocks,
      takeaway: viewModel.takeaway,
      cardColor: AppColors.bgCard,
      panelColor: AppColors.bgCard2,
      borderColor: AppColors.border,
      accentColor: AppColors.amber,
      hitColor: AppColors.rose,
      strongColor: AppColors.rose,
      currentColor: AppColors.amber,
      secondaryColor: AppColors.amber,
      textColor: AppColors.text,
      softColor: AppColors.textSoft,
      mutedColor: AppColors.textDim,
    );
  }
}
