import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import '../banner/alert_banner_action.dart';
import '../banner/alert_banner_item.dart';
import '../banner/alert_banner_severity.dart';
import '../banner/alert_banner_time_formatter.dart';
import 'alert_banner_action_row.dart';
import 'alert_banner_countdown_chip.dart';

class ActiveAlertBanner extends StatelessWidget {
  final AlertBannerItem item;
  final ValueChanged<AlertBannerAction>? onAction;
  final DateTime? now;

  const ActiveAlertBanner({
    super.key,
    required this.item,
    this.onAction,
    this.now,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.snoozed ? AppColors.textSoft : _color(item.severity);
    final icon = item.snoozed ? Icons.notifications_paused_rounded : _icon();
    final currentTime = now ?? DateTime.now();
    const formatter = AlertBannerTimeFormatter();
    final countdown =
        item.countdownLabel ??
        (item.snoozedUntil == null
            ? null
            : formatter.countdown(item.snoozedUntil!, currentTime));
    return Semantics(
      label: item.title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              item.snoozed ? AppColors.bgCard2 : color.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                item.snoozed
                    ? AppColors.borderMid
                    : color.withValues(alpha: .30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: item.snoozed ? .10 : .14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: item.snoozed ? AppColors.text : color,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (countdown != null) ...[
                          const SizedBox(width: 8),
                          AlertBannerCountdownChip(label: countdown),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: item.snoozed ? AppColors.textSoft : color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    if (onAction != null && item.actions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      AlertBannerActionRow(
                        actions: item.actions,
                        color: color,
                        onAction: onAction!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _color(AlertBannerSeverity severity) {
    return switch (severity) {
      AlertBannerSeverity.critical => AppColors.rose,
      AlertBannerSeverity.warning => AppColors.amber,
      AlertBannerSeverity.info => AppColors.blue,
    };
  }

  IconData _icon() {
    final explicit = item.metadata['icon'];
    if (explicit is IconData) return explicit;
    return switch (item.severity) {
      AlertBannerSeverity.critical => Icons.priority_high_rounded,
      AlertBannerSeverity.warning => Icons.warning_amber_rounded,
      AlertBannerSeverity.info => Icons.info_outline_rounded,
    };
  }
}
