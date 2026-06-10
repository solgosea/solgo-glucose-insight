import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../shared/episode_context_card.dart';
import '../shared/episode_pattern_card.dart';
import '../shared/episode_similar_card.dart';

import 'episode_kind.dart';
import 'episode_severity_view_model.dart';

class EpisodeHeroViewModel {
  final String valueLabel;
  final String valueText;
  final String valueUnit;
  final Color valueColor;
  final String durationText;
  final String durationRange;
  final String onsetRateLabel;
  final String onsetRateText;
  final Color onsetRateColor;
  final String recoveryRateText;
  final String areaLabel;
  final String areaText;
  final Color areaColor;
  final Color heroBg;
  final Color heroBorder;
  final bool showNocturnalBadge;

  const EpisodeHeroViewModel({
    required this.valueLabel,
    required this.valueText,
    required this.valueUnit,
    required this.valueColor,
    required this.durationText,
    required this.durationRange,
    required this.onsetRateLabel,
    required this.onsetRateText,
    required this.onsetRateColor,
    required this.recoveryRateText,
    required this.areaLabel,
    required this.areaText,
    required this.areaColor,
    required this.heroBg,
    required this.heroBorder,
    this.showNocturnalBadge = false,
  });
}

class EpisodeChartViewModel {
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final DateTime onsetTime;
  final DateTime peakOrNadirTime;
  final DateTime? recoveryTime;
  final Color themeColor;
  final ChartEpisode episode;

  const EpisodeChartViewModel({
    required this.readings,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    required this.onsetTime,
    required this.peakOrNadirTime,
    required this.recoveryTime,
    required this.themeColor,
    required this.episode,
  });
}

class EpisodePatternViewModel {
  final String bigStat;
  final String description;
  final Color statColor;
  final List<PatternDayIndicator> indicators;
  final Color activeDotColor;
  final String patternText;
  final String? extraNote;
  final String caveat;

  const EpisodePatternViewModel({
    required this.bigStat,
    required this.description,
    required this.statColor,
    required this.indicators,
    required this.activeDotColor,
    required this.patternText,
    this.extraNote,
    required this.caveat,
  });
}

class EpisodeDetailViewModel {
  final EpisodeKind kind;
  final String statusTime;
  final String title;
  final String subtitle;
  final EpisodeHeroViewModel? hero;
  final EpisodeChartViewModel? chart;
  final List<EpisodeContextRow> contextRows;
  final EpisodePatternViewModel? pattern;
  final EpisodeSeverityViewModel? severity;
  final String similarHeader;
  final List<EpisodeSimilarCardData> similarCards;
  final String disclaimer;
  final String emptyText;

  const EpisodeDetailViewModel({
    required this.kind,
    required this.statusTime,
    required this.title,
    required this.subtitle,
    required this.hero,
    required this.chart,
    required this.contextRows,
    required this.pattern,
    required this.severity,
    required this.similarHeader,
    required this.similarCards,
    required this.disclaimer,
    required this.emptyText,
  });

  bool get hasEpisode => hero != null && chart != null && pattern != null;
}
