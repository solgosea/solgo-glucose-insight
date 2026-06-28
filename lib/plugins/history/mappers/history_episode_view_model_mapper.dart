import 'package:flutter/material.dart';

import '../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../foundation/theme/app_colors.dart';
import '../application/i18n/history_l10n_resolver.dart';
import '../domain/history_episode_navigation_target.dart';
import '../domain/sections/history_episode_section.dart';
import '../l10n/generated/history_localizations.dart';
import '../models/history_view_model.dart';
import '../../explore/episode_detail/models/episode_kind.dart';

class HistoryEpisodeViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;

  const HistoryEpisodeViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  List<HistoryEpisodeCalloutViewModel> map(
      HistoryEpisodeSection section, AppSettings settings,
      {required DateTime selectedDay, HistoryLocalizations? l10n}) {
    final strings = l10n ?? HistoryL10nResolver.fallback;
    return [
      for (final context in section.episodes)
        _callout(context.event, settings, selectedDay, strings),
    ];
  }

  HistoryEpisodeCalloutViewModel _callout(
    GlucoseEvent event,
    AppSettings settings,
    DateTime selectedDay,
    HistoryLocalizations l10n,
  ) {
    final isHigh = event.type == GlucoseEventType.highEpisode;
    final target = HistoryEpisodeNavigationTarget(
      kind: isHigh ? EpisodeKind.high : EpisodeKind.low,
      eventTime: event.time,
      endTime: event.endTime,
      value: event.peakOrNadir ?? event.value,
      durationMinutes: event.durationMinutes,
      sourceDay: selectedDay,
    );
    return HistoryEpisodeCalloutViewModel(
      color: isHigh ? AppColors.rose : AppColors.blue,
      icon: isHigh ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
      kind: isHigh ? 'high' : 'low',
      timeLabel: _hm(event.time),
      title: isHigh ? l10n.episodeHigh : l10n.episodeLow,
      meta: _meta(event, settings, isHigh, l10n),
      value: glucoseFormatter
          .value(event.peakOrNadir ?? event.value, settings.unit)
          .valueLabel,
      unit: glucoseFormatter
          .value(event.peakOrNadir ?? event.value, settings.unit)
          .unitLabel,
      route: target.route(),
      navigationTarget: target,
    );
  }

  String _meta(
    GlucoseEvent event,
    AppSettings settings,
    bool isHigh,
    HistoryLocalizations l10n,
  ) {
    final parts = <String>['${event.durationMinutes} ${l10n.episodeMinutes}'];
    final threshold = isHigh ? settings.highThreshold : settings.lowThreshold;
    final thresholdLabel = glucoseFormatter.value(threshold, settings.unit);
    parts.add(
      isHigh
          ? l10n.episodeAboveThreshold(thresholdLabel.fullLabel)
          : l10n.episodeBelowThreshold(thresholdLabel.fullLabel),
    );
    if (event.isNocturnal) {
      parts.add(l10n.episodeNocturnal);
    }
    final rate = event.ratePerMin;
    if (rate != null && rate.abs() > 0.05) {
      parts.add(glucoseFormatter.rate(rate, settings.unit).fullLabel);
    }
    return parts.join(' · ');
  }

  String _hm(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
