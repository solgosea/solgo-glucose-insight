import 'package:flutter/material.dart';

import '../../models/status_hub_view_model.dart';
import '../status_hub_visuals.dart';
import '../../../styles/status_monitor_theme.dart';

class StatusHubPathScoreBadge extends StatelessWidget {
  final StatusHubPathScoreViewModel score;
  final bool compact;

  const StatusHubPathScoreBadge({
    super.key,
    required this.score,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(score.state);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.42)),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(.16), blurRadius: compact ? 8 : 12),
        ],
      ),
      child: Text(
        score.overallLabel,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: StatusMonitorTheme.mono.copyWith(
          color: color,
          fontSize: compact ? 9.5 : 12,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
