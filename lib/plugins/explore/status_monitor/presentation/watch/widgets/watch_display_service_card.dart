import 'package:flutter/material.dart';

import '../models/watch_detail_view_model.dart';
import 'primitives/watch_detail_primitives.dart';

class WatchDisplayServiceCard extends StatelessWidget {
  final List<WatchMetricTileViewModel> facts;

  const WatchDisplayServiceCard({super.key, required this.facts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 620 ? 4 : 2;
          final width = (constraints.maxWidth - ((columns - 1) * 8)) / columns;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facts
                .map(
                  (fact) => SizedBox(
                    width: width,
                    height: constraints.maxWidth >= 620 ? 116 : 124,
                    child: WatchMetricTile(
                      label: fact.label,
                      value: fact.value,
                      body: fact.body,
                      level: fact.level,
                      score: fact.score,
                    ),
                  ),
                )
                .toList(growable: false),
          );
        },
      ),
    );
  }
}
