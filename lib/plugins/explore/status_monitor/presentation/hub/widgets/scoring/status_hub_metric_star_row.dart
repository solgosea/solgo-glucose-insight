import 'package:flutter/material.dart';

import '../../models/status_hub_view_model.dart';
import '../status_hub_visuals.dart';
import 'status_hub_metric_star_rating.dart';
import '../../../styles/status_monitor_theme.dart';

class StatusHubMetricStarRow extends StatelessWidget {
  final StatusHubPathMetricScoreViewModel metric;

  const StatusHubMetricStarRow({
    super.key,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(metric.state);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: Text(
              metric.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.soft,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          StatusHubMetricStarRating(stars: metric.stars, color: color),
          const SizedBox(width: 8),
          SizedBox(
            width: 66,
            child: Text(
              metric.rawValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: StatusMonitorTheme.mono.copyWith(
                color: StatusMonitorTheme.text,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
