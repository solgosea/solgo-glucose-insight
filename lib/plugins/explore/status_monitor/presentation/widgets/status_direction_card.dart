import 'package:flutter/material.dart';

import '../../domain/status_direction.dart';
import '../styles/status_monitor_theme.dart';

class StatusDirectionCard extends StatelessWidget {
  final List<StatusDirection> directions;

  const StatusDirectionCard({super.key, required this.directions});

  @override
  Widget build(BuildContext context) {
    final visibleDirections = directions
        .where(
          (direction) =>
              direction.title.trim().isNotEmpty ||
              direction.body.trim().isNotEmpty,
        )
        .toList(growable: false);
    if (visibleDirections.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: StatusMonitorTheme.cardDecoration(),
      child: Column(
        children: [
          for (var i = 0; i < visibleDirections.length; i++) ...[
            if (i > 0)
              Divider(color: StatusMonitorTheme.green.withOpacity(.10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 23,
                  height: 23,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: StatusMonitorTheme.green.withOpacity(.10),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: StatusMonitorTheme.mono.copyWith(
                      color: StatusMonitorTheme.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (visibleDirections[i].title.trim().isNotEmpty)
                        Text(
                          visibleDirections[i].title,
                          style: StatusMonitorTheme.inter.copyWith(
                            color: StatusMonitorTheme.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      if (visibleDirections[i].body.trim().isNotEmpty) ...[
                        if (visibleDirections[i].title.trim().isNotEmpty)
                          const SizedBox(height: 4),
                        Text(
                          visibleDirections[i].body,
                          style: StatusMonitorTheme.inter.copyWith(
                            color: StatusMonitorTheme.soft,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                      if (visibleDirections[i].linkLabel != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          '${visibleDirections[i].linkLabel} >',
                          style: StatusMonitorTheme.mono.copyWith(
                            color: StatusMonitorTheme.blue,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
