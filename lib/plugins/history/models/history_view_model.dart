import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';

class HistoryViewModel {
  final HistoryDateNavViewModel dateNav;
  final List<HistorySummaryChipViewModel> summaryChips;
  final HistoryCurveViewModel curve;
  final List<HistoryStatCardViewModel> stats;
  final List<HistoryEpisodeCalloutViewModel> episodeCallouts;
  final List<HistoryEventRowViewModel> events;

  const HistoryViewModel({
    required this.dateNav,
    required this.summaryChips,
    required this.curve,
    required this.stats,
    required this.episodeCallouts,
    required this.events,
  });
}

class HistoryDateNavViewModel {
  final String dateLabel;
  final String subtitle;
  final bool isToday;

  const HistoryDateNavViewModel({
    required this.dateLabel,
    required this.subtitle,
    required this.isToday,
  });
}

class HistorySummaryChipViewModel {
  final String text;
  final Color color;

  const HistorySummaryChipViewModel({required this.text, required this.color});
}

class HistoryCurveViewModel {
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final List<ChartEpisode> episodes;
  final List<ChartEventMarker> markers;

  const HistoryCurveViewModel({
    required this.readings,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    required this.episodes,
    required this.markers,
  });
}

class HistoryStatCardViewModel {
  final String label;
  final String value;
  final String? unit;
  final Color color;

  const HistoryStatCardViewModel({
    required this.label,
    required this.value,
    required this.color,
    this.unit,
  });
}

class HistoryEpisodeCalloutViewModel {
  final Color color;
  final IconData icon;
  final String label;
  final String summary;
  final String actionLabel;
  final String route;

  const HistoryEpisodeCalloutViewModel({
    required this.color,
    required this.icon,
    required this.label,
    required this.summary,
    required this.actionLabel,
    required this.route,
  });
}

class HistoryEventRowViewModel {
  final String time;
  final String name;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Color iconBorder;
  final String detail;
  final String valueLabel;
  final Color valueColor;
  final HistoryEventTagViewModel? tag;

  const HistoryEventRowViewModel({
    required this.time,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.iconBorder,
    required this.detail,
    required this.valueLabel,
    required this.valueColor,
    this.tag,
  });
}

class HistoryEventTagViewModel {
  final String text;
  final Color color;

  const HistoryEventTagViewModel({required this.text, required this.color});
}
