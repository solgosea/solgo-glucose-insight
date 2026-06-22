import 'package:flutter/material.dart';

import '../../../application/i18n/status_monitor_l10n.dart';
import '../../../application/i18n/status_monitor_status_level_localizer.dart';
import '../../../domain/status_level.dart';
import '../../styles/status_monitor_theme.dart';
import '../models/status_history_cell_view_model.dart';

class StatusHourlyHeatmap extends StatelessWidget {
  final List<List<StatusHistoryCellViewModel>> rows;

  const StatusHourlyHeatmap({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          _HeatmapRow(cells: rows[i]),
          if (i < rows.length - 1) const SizedBox(height: 3),
        ],
        const SizedBox(height: 7),
        const _HeatmapAxis(),
      ],
    );
  }
}

class _HeatmapRow extends StatelessWidget {
  final List<StatusHistoryCellViewModel> cells;

  const _HeatmapRow({required this.cells});

  @override
  Widget build(BuildContext context) {
    final label = cells.isEmpty ? '' : cells.first.label;
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Text(
            label,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StatusMonitorTheme.mono.copyWith(
              color: StatusMonitorTheme.dim,
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Row(
            children: [
              for (var i = 0; i < cells.length; i++) ...[
                Expanded(child: _HeatmapCell(cell: cells[i])),
                if (i < cells.length - 1) const SizedBox(width: 2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  final StatusHistoryCellViewModel cell;

  const _HeatmapCell({required this.cell});

  @override
  Widget build(BuildContext context) {
    final level = cell.level;
    final l10n = context.statusMonitorL10n;
    final color = StatusMonitorTheme.colorFor(level);
    final score = cell.score == null ? '' : ' - ${cell.score}';
    return Tooltip(
      message:
          '${cell.reasonLabel}$score\n${cell.summary.isEmpty ? statusMonitorLevelLabel(level, l10n) : cell.summary}',
      child: Container(
        height: 13,
        decoration: BoxDecoration(
          color: color.withOpacity(_opacity(level)),
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: color.withOpacity(level == StatusLevel.unknown ? .10 : .08),
            width: .5,
          ),
        ),
      ),
    );
  }

  double _opacity(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => .42,
      StatusLevel.watch => .55,
      StatusLevel.issue => .60,
      StatusLevel.unknown => .30,
    };
  }
}

class _HeatmapAxis extends StatelessWidget {
  const _HeatmapAxis();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 38),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in const ['00', '06', '12', '18', '24'])
                Text(
                  label,
                  style: StatusMonitorTheme.mono.copyWith(
                    color: StatusMonitorTheme.dim,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
