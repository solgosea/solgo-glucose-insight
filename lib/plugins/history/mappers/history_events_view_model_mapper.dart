import 'package:flutter/material.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../foundation/theme/app_colors.dart';
import '../application/i18n/history_l10n_resolver.dart';
import '../application/text/history_event_text_builder.dart';
import '../domain/sections/history_events_section.dart';
import '../l10n/generated/history_localizations.dart';
import '../models/history_view_model.dart';

class HistoryEventsViewModelMapper {
  final HistoryEventTextBuilder textBuilder;

  const HistoryEventsViewModelMapper({
    this.textBuilder = const HistoryEventTextBuilder(),
  });

  List<HistoryEventRowViewModel> map(
    HistoryEventsSection section,
    AppSettings settings, {
    HistoryLocalizations? l10n,
  }) {
    final strings = l10n ?? HistoryL10nResolver.fallback;
    return [
      for (final context in section.events)
        _eventRow(context.event, settings, strings),
    ];
  }

  HistoryEventRowViewModel _eventRow(
    GlucoseEvent event,
    AppSettings settings,
    HistoryLocalizations l10n,
  ) {
    final spec = _eventIconSpec(event.type);
    final tint =
        _eventIconTint(event.type, event.peakOrNadir ?? event.value, settings);
    return HistoryEventRowViewModel(
      time: _hm(event.time),
      name: _eventName(event.type, l10n),
      icon: spec.icon,
      iconColor: spec.color,
      iconBackground: tint?.bg ?? spec.color.withOpacity(0.10),
      iconBorder: tint?.border ?? spec.color.withOpacity(0.30),
      detail: textBuilder.detail(event, settings, l10n: l10n),
      valueLabel: textBuilder.valueLabel(event, settings, l10n: l10n),
      valueColor: _eventValueColor(event, settings),
      tag: _eventTag(event, settings, l10n),
    );
  }

  String _eventName(GlucoseEventType type, HistoryLocalizations l10n) =>
      switch (type) {
        GlucoseEventType.highEpisode => l10n.eventRiseDetected,
        GlucoseEventType.lowEpisode => l10n.eventLowEpisode,
        GlucoseEventType.rise => l10n.eventRiseDetected,
        GlucoseEventType.recovery => l10n.eventRecoveryToRange,
        GlucoseEventType.stableWindow => l10n.eventStableWindow,
        GlucoseEventType.firstReading => l10n.eventFirstReading,
        GlucoseEventType.dawnPhenomenon => l10n.eventDawnPhenomenon,
      };

  ({IconData icon, Color color}) _eventIconSpec(GlucoseEventType type) =>
      switch (type) {
        GlucoseEventType.highEpisode => (
            icon: Icons.arrow_upward_rounded,
            color: AppColors.rose
          ),
        GlucoseEventType.lowEpisode => (
            icon: Icons.arrow_downward_rounded,
            color: AppColors.blue
          ),
        GlucoseEventType.rise => (
            icon: Icons.trending_up_rounded,
            color: AppColors.amber
          ),
        GlucoseEventType.recovery => (
            icon: Icons.south_east_rounded,
            color: AppColors.green
          ),
        GlucoseEventType.stableWindow => (
            icon: Icons.timeline_rounded,
            color: AppColors.green
          ),
        GlucoseEventType.firstReading => (
            icon: Icons.wb_sunny_outlined,
            color: AppColors.amber
          ),
        GlucoseEventType.dawnPhenomenon => (
            icon: Icons.wb_twilight_rounded,
            color: AppColors.amber
          ),
      };

  ({Color bg, Color border})? _eventIconTint(
    GlucoseEventType type,
    double value,
    AppSettings settings,
  ) {
    if (type == GlucoseEventType.highEpisode ||
        value > settings.highThreshold) {
      return (
        bg: AppColors.rose.withOpacity(0.12),
        border: AppColors.rose.withOpacity(0.25),
      );
    }
    if (type == GlucoseEventType.lowEpisode || value < settings.lowThreshold) {
      return (
        bg: AppColors.blue.withOpacity(0.12),
        border: AppColors.blue.withOpacity(0.25),
      );
    }
    if (type == GlucoseEventType.recovery ||
        type == GlucoseEventType.stableWindow) {
      return (
        bg: AppColors.green.withOpacity(0.12),
        border: AppColors.green.withOpacity(0.25),
      );
    }
    return null;
  }

  Color _eventValueColor(GlucoseEvent event, AppSettings settings) {
    final value = event.peakOrNadir ?? event.value;
    if (value > settings.highThreshold) return AppColors.rose;
    if (value < settings.lowThreshold) return AppColors.blue;
    if (_isElevated(value, settings)) return AppColors.amber;
    return AppColors.text;
  }

  HistoryEventTagViewModel? _eventTag(
    GlucoseEvent event,
    AppSettings settings,
    HistoryLocalizations l10n,
  ) {
    if (event.type == GlucoseEventType.highEpisode) {
      return HistoryEventTagViewModel(
        text: l10n.tagHighEpisode,
        color: AppColors.amber,
      );
    }
    if (event.type == GlucoseEventType.lowEpisode) {
      return HistoryEventTagViewModel(
        text: l10n.tagLowEpisode,
        color: AppColors.blue,
      );
    }
    if (event.type == GlucoseEventType.recovery) {
      return HistoryEventTagViewModel(
        text: l10n.tagInRange,
        color: AppColors.green,
      );
    }
    final value = event.peakOrNadir ?? event.value;
    if (event.type == GlucoseEventType.rise && _isElevated(value, settings)) {
      return HistoryEventTagViewModel(
        text: l10n.tagElevated,
        color: AppColors.amber,
      );
    }
    return null;
  }

  bool _isElevated(double value, AppSettings settings) {
    final lowerBand = settings.highThreshold -
        (settings.highThreshold - settings.lowThreshold) * 0.15;
    return value >= lowerBand && value <= settings.highThreshold;
  }

  String _hm(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
