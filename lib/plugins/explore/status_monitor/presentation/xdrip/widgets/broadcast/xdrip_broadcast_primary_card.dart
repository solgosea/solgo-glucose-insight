import 'package:flutter/material.dart';

import '../../../../domain/status_level.dart';
import '../../../../domain/xdrip/xdrip_broadcast_readiness.dart';
import '../../../styles/status_monitor_theme.dart';
import '../xdrip_detail_section_frame.dart';

class XdripBroadcastPrimaryCard extends StatelessWidget {
  final XdripBroadcastReadiness readiness;

  const XdripBroadcastPrimaryCard({super.key, required this.readiness});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(readiness.level);
    return XdripDetailSectionFrame(
      title: 'xDrip+ local broadcast',
      trailing: 'primary path',
      child: XdripGlassPanel(
        level: readiness.level,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withOpacity(.26)),
                  ),
                  child: Icon(
                    Icons.sensors_rounded,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        readiness.stateLabel,
                        style: StatusMonitorTheme.inter.copyWith(
                          color: color,
                          fontSize: 22,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Latest ${readiness.latestLabel} - ${readiness.payloadLabel}',
                        style: StatusMonitorTheme.inter.copyWith(
                          color: StatusMonitorTheme.soft,
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                _Badge(label: _levelLabel(readiness.level), color: color),
              ],
            ),
            const SizedBox(height: 14),
            _GuidanceRow(
              icon: Icons.route_rounded,
              title: 'AAPS path',
              body:
                  'AAPS uses xDrip+ local broadcast for BG source flow. xDrip+ Web Server is not required for this path.',
            ),
            const SizedBox(height: 10),
            _GuidanceRow(
              icon: Icons.verified_user_outlined,
              title: 'Receiver package',
              body:
                  'For AAPS, identify receiver ${readiness.receiverPackage}. For SolgoInsight observation, allow com.metaguru.smartxdrip.',
            ),
          ],
        ),
      ),
    );
  }

  String _levelLabel(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => 'Observed',
      StatusLevel.watch => 'Watch',
      StatusLevel.issue => 'Issue',
      StatusLevel.unknown => 'Unknown',
    };
  }
}

class _GuidanceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _GuidanceRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: StatusMonitorTheme.teal, size: 17),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: StatusMonitorTheme.inter.copyWith(
                color: StatusMonitorTheme.soft,
                fontSize: 11.2,
                height: 1.42,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(
                    color: StatusMonitorTheme.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.35)),
      ),
      child: Text(
        label.toUpperCase(),
        style: StatusMonitorTheme.mono.copyWith(
          color: color,
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
