import 'package:flutter/material.dart';

import '../../../../domain/status_level.dart';
import '../../../styles/status_monitor_theme.dart';

BoxDecoration watchCardDecoration([StatusLevel level = StatusLevel.unknown]) {
  final color = StatusMonitorTheme.colorFor(level);
  return BoxDecoration(
    color: StatusMonitorTheme.card,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: color.withOpacity(.18)),
    boxShadow: const [
      BoxShadow(
        color: Color(0x29000000),
        blurRadius: 28,
        offset: Offset(0, 10),
      ),
    ],
  );
}

class WatchScoreRing extends StatelessWidget {
  final int score;
  final StatusLevel level;

  const WatchScoreRing({
    super.key,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            color,
            color,
            color.withOpacity(.14),
            color.withOpacity(.14),
          ],
          stops: [0, score.clamp(0, 100) / 100, score.clamp(0, 100) / 100, 1],
        ),
        border: Border.all(color: color.withOpacity(.24)),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: StatusMonitorTheme.card,
          border: Border.all(color: Colors.black.withOpacity(.18)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: StatusMonitorTheme.mono.copyWith(
                  color: color,
                  fontSize: 27,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'SCORE',
                style: StatusMonitorTheme.mono.copyWith(
                  color: StatusMonitorTheme.soft,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WatchPathNode extends StatelessWidget {
  final String title;
  final String subtitle;
  final StatusLevel level;

  const WatchPathNode({
    super.key,
    required this.title,
    required this.subtitle,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x6B08110D),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(.20)),
      ),
      child: Column(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.text,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class WatchStatusMark extends StatelessWidget {
  final StatusLevel level;

  const WatchStatusMark({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    final icon = switch (level) {
      StatusLevel.healthy => Icons.check_rounded,
      StatusLevel.watch => Icons.priority_high_rounded,
      StatusLevel.issue => Icons.close_rounded,
      StatusLevel.unknown => Icons.question_mark_rounded,
    };
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: color.withOpacity(.72)),
      ),
      child: Center(
        child: Icon(
          icon,
          color: color,
          size: 18,
        ),
      ),
    );
  }
}

class WatchMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String body;
  final StatusLevel level;
  final double score;

  const WatchMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.body,
    required this.level,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x5908110D),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: StatusMonitorTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.inter.copyWith(
              color: StatusMonitorTheme.soft,
              fontSize: 10,
              height: 1.30,
            ),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: score.clamp(0, 1),
              color: color,
              backgroundColor: Colors.white.withOpacity(.06),
            ),
          ),
        ],
      ),
    );
  }
}
