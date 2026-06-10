import 'package:flutter/material.dart';
import '../models/history_view_model.dart';
import 'history_episode_callout_card.dart';

class HistoryEpisodeCallouts extends StatelessWidget {
  final List<HistoryEpisodeCalloutViewModel> callouts;
  final ValueChanged<String> onRouteSelected;

  const HistoryEpisodeCallouts({
    super.key,
    required this.callouts,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          callouts
              .map(
                (callout) => HistoryEpisodeCalloutCard(
                  viewModel: callout,
                  onTap: () => onRouteSelected(callout.route),
                ),
              )
              .toList(),
    );
  }
}
