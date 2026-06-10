import 'package:flutter/material.dart';
import '../models/home_stat_card_view_model.dart';
import 'home_stat_card.dart';

class HomeStatsRow extends StatelessWidget {
  final List<HomeStatCardViewModel> stats;

  const HomeStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(child: HomeStatCard(viewModel: stats[i])),
          if (i != stats.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}
