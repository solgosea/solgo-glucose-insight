import 'package:flutter/material.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';
import '../models/history_view_model.dart';
import 'history_curve_card.dart';
import 'history_date_nav.dart';
import 'history_episode_callouts.dart';
import 'history_events_list.dart';
import 'history_page_title.dart';
import 'history_stats_grid.dart';
import 'history_summary_chips.dart';

class HistoryBody extends StatelessWidget {
  final HistoryViewModel viewModel;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final ValueChanged<String> onRouteSelected;

  const HistoryBody({
    super.key,
    required this.viewModel,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HistoryPageTitle(),
            HistoryDateNav(
              viewModel: viewModel.dateNav,
              onPrevious: onPreviousDay,
              onNext: onNextDay,
            ),
            const SizedBox(height: 4),
            HistorySummaryChips(chips: viewModel.summaryChips),
            const SizedBox(height: 4),
            HistoryCurveCard(viewModel: viewModel.curve),
            HistoryStatsGrid(stats: viewModel.stats),
            HistoryEpisodeCallouts(
              callouts: viewModel.episodeCallouts,
              onRouteSelected: onRouteSelected,
            ),
            const SectionLabel('GLUCOSE EVENTS'),
            HistoryEventsList(events: viewModel.events),
          ],
        ),
      ),
    );
  }
}
