import 'package:flutter/material.dart';

import '../../domain/status_report.dart';
import '../styles/status_monitor_theme.dart';
import 'status_level_pill.dart';

class StatusSummaryBar extends StatelessWidget {
  final StatusSummary summary;

  const StatusSummaryBar({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(summary.level);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 340;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(compact ? 14 : 16),
          decoration: StatusMonitorTheme.cardDecoration(
            level: summary.level,
            elevated: true,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 38 : 42,
                height: compact ? 38 : 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.monitor_heart_rounded,
                  color: color,
                  size: compact ? 20 : 22,
                ),
              ),
              SizedBox(width: compact ? 10 : 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            summary.headline,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: StatusMonitorTheme.inter.copyWith(
                              color: StatusMonitorTheme.text,
                              fontSize: compact ? 14 : 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusLevelPill(level: summary.level, compact: compact),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      summary.body,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: compact ? 12 : 12.5,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      summary.meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.dim,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
