import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';

class StatusHubMetricStarRating extends StatelessWidget {
  final int stars;
  final Color color;

  const StatusHubMetricStarRating({
    super.key,
    required this.stars,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Icon(
            i < stars ? Icons.star_rounded : Icons.star_border_rounded,
            size: 13,
            color: i < stars ? color : StatusMonitorTheme.dim.withOpacity(.45),
          ),
      ],
    );
  }
}
