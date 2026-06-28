import 'package:flutter/material.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';
import '../application/i18n/history_l10n.dart';
import '../models/history_view_model.dart';
import 'history_curve_card.dart';
import 'history_date_nav.dart';
import 'history_episodes_panel.dart';
import 'history_events_list.dart';
import 'history_page_title.dart';
import 'history_stats_grid.dart';
import 'history_summary_chips.dart';
import 'history_time_filter_banner.dart';

class HistoryBody extends StatelessWidget {
  final HistoryViewModel viewModel;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;
  final ValueChanged<DateTime> onTimeSelected;
  final VoidCallback onClearTimeFilter;
  final VoidCallback onDateFilterPressed;
  final ValueChanged<String> onRouteSelected;

  const HistoryBody({
    super.key,
    required this.viewModel,
    required this.onPreviousDay,
    required this.onNextDay,
    required this.onTimeSelected,
    required this.onClearTimeFilter,
    required this.onDateFilterPressed,
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
            HistoryPageTitle(onDateFilterPressed: onDateFilterPressed),
            HistoryDateNav(
              viewModel: viewModel.dateNav,
              onPrevious: onPreviousDay,
              onNext: onNextDay,
            ),
            const SizedBox(height: 4),
            HistorySummaryChips(chips: viewModel.summaryChips),
            const SizedBox(height: 4),
            HistoryCurveCard(
              viewModel: viewModel.curve,
              onTimeSelected: onTimeSelected,
            ),
            if (viewModel.timeFilter != null)
              HistoryTimeFilterBanner(
                viewModel: viewModel.timeFilter!,
                onClear: onClearTimeFilter,
              ),
            HistoryStatsGrid(stats: viewModel.stats),
            HistoryEpisodesPanel(
              episodes: viewModel.episodeCallouts,
              onRouteSelected: onRouteSelected,
            ),
            SectionLabel(context.historyL10n.eventsSectionTitle),
            HistoryEventsList(events: viewModel.events),
          ],
        ),
      ),
    );
  }
}
