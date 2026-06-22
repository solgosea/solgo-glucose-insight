import 'package:flutter/material.dart';

import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/status_history_cell_view_model.dart';

class StatusDailySummaryRow extends StatelessWidget {
  final List<StatusHistoryCellViewModel> cells;

  const StatusDailySummaryRow({super.key, required this.cells});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < cells.length; i++) ...[
          Expanded(child: _DailyCell(cell: cells[i])),
          if (i < cells.length - 1) const SizedBox(width: 5),
        ],
      ],
    );
  }
}

class _DailyCell extends StatelessWidget {
  final StatusHistoryCellViewModel cell;

  const _DailyCell({required this.cell});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(cell.level);
    return Tooltip(
      message: '${cell.reasonLabel}\n${cell.summary}',
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(_fillOpacity(cell.level) + .05),
              color.withOpacity(_fillOpacity(cell.level)),
            ],
          ),
          border:
              Border.all(color: color.withOpacity(_borderOpacity(cell.level))),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cell.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StatusMonitorTheme.mono.copyWith(
                color: cell.level == StatusLevel.unknown
                    ? StatusMonitorTheme.soft
                    : color,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            _StatusGlyph(level: cell.level),
          ],
        ),
      ),
    );
  }

  double _fillOpacity(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => .18,
      StatusLevel.watch => .22,
      StatusLevel.issue => .26,
      StatusLevel.unknown => .18,
    };
  }

  double _borderOpacity(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => .28,
      StatusLevel.watch => .34,
      StatusLevel.issue => .40,
      StatusLevel.unknown => .34,
    };
  }
}

class _StatusGlyph extends StatelessWidget {
  final StatusLevel level;

  const _StatusGlyph({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = StatusMonitorTheme.colorFor(level);
    final muted = level == StatusLevel.unknown;
    final size = switch (level) {
      StatusLevel.healthy => 11.0,
      StatusLevel.watch => 10.5,
      StatusLevel.issue => 10.5,
      StatusLevel.unknown => 8.5,
    };
    final radius = switch (level) {
      StatusLevel.healthy => size / 2,
      StatusLevel.watch => 2.5,
      StatusLevel.issue => 2.5,
      StatusLevel.unknown => size / 2,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: muted ? StatusMonitorTheme.dim.withOpacity(.58) : color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: muted
            ? null
            : [
                BoxShadow(
                  color: color.withOpacity(.24),
                  blurRadius: 7,
                ),
              ],
      ),
    );
  }
}
