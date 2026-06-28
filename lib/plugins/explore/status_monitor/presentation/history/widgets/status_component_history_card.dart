import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../../domain/status_component_kind.dart';
import '../../../domain/status_level.dart';
import '../../../l10n/generated/status_monitor_localizations.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/status_component_history_view_model.dart';
import 'status_daily_summary_row.dart';
import 'status_hourly_heatmap.dart';

class StatusComponentHistoryCard extends StatelessWidget {
  final StatusComponentHistoryViewModel component;

  const StatusComponentHistoryCard({
    super.key,
    required this.component,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final color = StatusMonitorTheme.colorFor(component.currentLevel);
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: StatusMonitorTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: StatusMonitorTheme.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: color.withOpacity(.24)),
                ),
                child: Icon(
                  _iconFor(component.component),
                  color: color,
                  size: 17,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _componentTitle(component.component, l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StatusMonitorTheme.inter.copyWith(
                        color: StatusMonitorTheme.text,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.pageSamplesRecorded(
                        (component.coverage * 100).round(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StatusMonitorTheme.mono.copyWith(
                        color: StatusMonitorTheme.dim,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _CurrentPill(level: component.currentLevel, l10n: l10n),
            ],
          ),
          const SizedBox(height: 12),
          _ViewLabel(l10n.pageDailySummary7Days),
          const SizedBox(height: 6),
          StatusDailySummaryRow(cells: component.dailyCells),
          const SizedBox(height: 14),
          _ViewLabel(l10n.pageHourlyDetail),
          const SizedBox(height: 6),
          StatusHourlyHeatmap(rows: component.hourlyRows),
        ],
      ),
    );
  }

  IconData _iconFor(StatusComponentKind kind) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => Icons.radio_button_checked_rounded,
      StatusComponentKind.juggluco => Icons.sensors_rounded,
      StatusComponentKind.xdrip => Icons.phone_android_rounded,
      StatusComponentKind.nightscout => Icons.cloud_rounded,
      StatusComponentKind.aapsLoop => Icons.loop_rounded,
      StatusComponentKind.watchDisplay => Icons.watch_rounded,
    };
  }

  String _componentTitle(
    StatusComponentKind kind,
    StatusMonitorLocalizations l10n,
  ) {
    return switch (kind) {
      StatusComponentKind.cgmSensor => l10n.pageComponentCgmSensor,
      StatusComponentKind.juggluco => 'Juggluco',
      StatusComponentKind.xdrip => l10n.pageComponentXdrip,
      StatusComponentKind.nightscout => l10n.pageComponentNightscout,
      StatusComponentKind.aapsLoop => l10n.pageComponentAapsLoop,
      StatusComponentKind.watchDisplay => 'Watch display',
    };
  }
}

class _CurrentPill extends StatelessWidget {
  final StatusLevel level;
  final StatusMonitorLocalizations l10n;

  const _CurrentPill({required this.level, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            _levelLabel(level, l10n),
            style: StatusMonitorTheme.mono.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: .4,
            ),
          ),
        ],
      ),
    );
  }

  String _levelLabel(StatusLevel level, StatusMonitorLocalizations l10n) {
    return switch (level) {
      StatusLevel.healthy => l10n.pageStatusHealthy,
      StatusLevel.watch => l10n.pageStatusWatch,
      StatusLevel.issue => l10n.pageStatusIssue,
      StatusLevel.unknown => l10n.pageStatusUnknown,
    };
  }
}

class _ViewLabel extends StatelessWidget {
  final String text;

  const _ViewLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: StatusMonitorTheme.mono.copyWith(
        color: StatusMonitorTheme.dim,
        fontSize: 9.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }
}
