import 'package:flutter/material.dart';
import '../models/history_view_model.dart';
import 'history_stat_card.dart';

class HistoryStatsGrid extends StatelessWidget {
  final List<HistoryStatCardViewModel> stats;

  const HistoryStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              Expanded(child: HistoryStatCard(viewModel: stats[i])),
              if (i < stats.length - 1) const SizedBox(width: 6),
            ],
          ],
        ),
      ),
    );
  }
}
