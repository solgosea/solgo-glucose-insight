import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../application/text/statistics_heatmap_text_builder.dart';
import '../domain/sections/statistics_heatmap_section.dart';
import '../domain/statistics_heatmap_tag.dart';
import '../models/statistics_view_model.dart';

class StatisticsHeatmapViewModelMapper {
  final StatisticsHeatmapTextBuilder textBuilder;

  const StatisticsHeatmapViewModelMapper({
    this.textBuilder = const StatisticsHeatmapTextBuilder(),
  });

  StatisticsHeatmapViewModel map(
    StatisticsHeatmapSection section, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return StatisticsHeatmapViewModel(
      title: textBuilder.title(context: context),
      cells: section.cells
          .map(
            (cell) => StatisticsHeatmapCellViewModel(
              hour: cell.hour,
              tirPct: cell.tirPct,
              color: _cellColor(cell.tirPct),
              timeLabel: '${cell.hour.toString().padLeft(2, '0')}:00',
              tirLabel: '${cell.tirPct.toStringAsFixed(0)}%',
              tagLabel: textBuilder.tagLabel(cell.tag, context: context),
              tagColor: _heatmapTagColor(cell.tag),
            ),
          )
          .toList(growable: false),
      labels: section.labels,
    );
  }

  Color _heatmapTagColor(StatisticsHeatmapTag tag) {
    return switch (tag) {
      StatisticsHeatmapTag.inTarget => AppColors.green,
      StatisticsHeatmapTag.belowTarget => AppColors.amber,
      StatisticsHeatmapTag.needsAttention => AppColors.rose,
    };
  }

  Color _cellColor(double tirPct) {
    final normalized = ((tirPct - 40) / 42).clamp(0.0, 1.0);
    int r;
    int g;
    int b;
    if (normalized < 0.45) {
      final f = normalized / 0.45;
      r = (240 + (110 - 240) * f).round();
      g = (180 + (232 - 180) * f).round();
      b = (78 + (158 - 78) * f).round();
    } else {
      r = 110;
      g = 232;
      b = 158;
    }
    final alpha = (0.15 + normalized * 0.68).clamp(0.0, 1.0);
    return Color.fromRGBO(r, g, b, alpha);
  }
}
