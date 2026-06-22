import 'package:flutter/material.dart';

import '../styles/status_monitor_theme.dart';

class StatusMonitorPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? eyebrow;
  final VoidCallback onBack;
  final Widget? trailing;

  const StatusMonitorPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    required this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: StatusMonitorTheme.text,
            style: IconButton.styleFrom(
              backgroundColor: StatusMonitorTheme.card2,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eyebrow != null) ...[
                    Text(
                      eyebrow!.toUpperCase(),
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.45,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                  Text(
                    title,
                    style: StatusMonitorTheme.inter.copyWith(
                      color: StatusMonitorTheme.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.12,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      subtitle!,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.soft,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}
