import 'package:flutter/material.dart';

import '../models/status_hub_view_model.dart';
import 'status_hub_visuals.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubConnectionChip extends StatelessWidget {
  final Size size;
  final double left;
  final double top;
  final double width;
  final double height;
  final StatusHubConnectionViewModel connection;

  const StatusHubConnectionChip({
    super.key,
    required this.size,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.connection,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusHubVisuals.colorFor(connection.pathScore.state);
    final score = connection.pathScore.overallLabel;
    return Positioned(
      left: size.width * left,
      top: size.height * top,
      width: size.width * width,
      height: size.height * height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: StatusMonitorTheme.bg.withOpacity(.94),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(.34)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              score,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StatusMonitorTheme.mono.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatusHubLegend extends StatelessWidget {
  final String label;
  final Color color;

  const StatusHubLegend({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: StatusMonitorTheme.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
