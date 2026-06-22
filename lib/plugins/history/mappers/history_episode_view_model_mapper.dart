import 'package:flutter/material.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../foundation/theme/app_colors.dart';
import '../application/text/history_episode_text_builder.dart';
import '../application/i18n/history_l10n_resolver.dart';
import '../domain/history_episode_navigation_target.dart';
import '../domain/sections/history_episode_section.dart';
import '../l10n/generated/history_localizations.dart';
import '../models/history_view_model.dart';
import '../../explore/episode_detail/models/episode_kind.dart';

class HistoryEpisodeViewModelMapper {
  final HistoryEpisodeTextBuilder textBuilder;

  const HistoryEpisodeViewModelMapper({
    this.textBuilder = const HistoryEpisodeTextBuilder(),
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
      label: isHigh ? l10n.episodeHigh : l10n.episodeLow,
      summary: textBuilder.calloutSummary(event, settings, l10n: l10n),
      actionLabel: l10n.episodeAction,
      route: target.route(),
      navigationTarget: target,
    );
  }
}
