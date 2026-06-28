import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/watch_detail_view_model.dart';
import 'primitives/watch_detail_primitives.dart';

class WatchDisplayEvidenceCard extends StatelessWidget {
  final WatchDisplayEvidenceViewModel evidence;

  const WatchDisplayEvidenceCard({super.key, required this.evidence});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(evidence.level);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: watchCardDecoration(evidence.level),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(.28)),
            ),
            child: Center(
              child: Icon(
                Icons.watch_rounded,
                color: color,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evidence.title,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.text,
                    fontSize: 13.5,
                    height: 1.24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 7,
                  runSpacing: 6,
                  children: [
                    _EvidenceChip(label: evidence.latestLabel, color: color),
                    _EvidenceChip(label: _stateLabel(), color: color),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  evidence.body,
                  style: StatusMonitorTheme.inter.copyWith(
                    color: StatusMonitorTheme.soft,
                    fontSize: 11.2,
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  evidence.sourceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.dim,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _stateLabel() {
    return switch (evidence.level) {
      StatusLevel.healthy => 'Yes',
      StatusLevel.watch => 'Watch',
      StatusLevel.issue => 'No',
      StatusLevel.unknown => 'Unknown',
    };
  }
}

class _EvidenceChip extends StatelessWidget {
  final String label;
  final Color color;

  const _EvidenceChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.45)),
        color: color.withOpacity(.06),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: StatusMonitorTheme.mono.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
