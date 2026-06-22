import 'package:flutter/material.dart';

import '../../application/i18n/status_monitor_l10n.dart';
import '../../application/i18n/status_monitor_status_level_localizer.dart';
import '../../domain/status_level.dart';
import '../styles/status_monitor_theme.dart';

class StatusLevelPill extends StatelessWidget {
  final StatusLevel level;
  final bool compact;

  const StatusLevelPill({
    super.key,
    required this.level,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 9,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          if (!compact) ...[
            const SizedBox(width: 6),
            Text(
              statusMonitorLevelLabel(level, l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StatusMonitorTheme.mono.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
