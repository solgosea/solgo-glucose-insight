import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_render_context.dart';

import '../styles/status_monitor_theme.dart';

class StatusMonitorEntryCard extends StatelessWidget {
  final PluginRenderContext renderContext;

  const StatusMonitorEntryCard({super.key, required this.renderContext});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => renderContext.buildContext.push('/explore/status'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: StatusMonitorTheme.cardDecoration(elevated: true),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: StatusMonitorTheme.green.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.monitor_heart_rounded,
                color: StatusMonitorTheme.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status Monitor',
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CGM, xDrip+, and Nightscout status lights',
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.soft,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: StatusMonitorTheme.green),
          ],
        ),
      ),
    );
  }
}
