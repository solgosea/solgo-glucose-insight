import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../../application/i18n/profile_l10n_resolver.dart';
import '../../l10n/generated/profile_localizations.dart';
import 'target_range_profile_view_model.dart';

class TargetRangeProfileViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;

  const TargetRangeProfileViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  TargetRangeProfileViewModel map(
    AppSettings settings, {
    ProfileLocalizations? l10n,
  }) {
    final strings = l10n ?? ProfileL10nResolver.fallback;
    final target = glucoseFormatter.range(
      settings.lowThreshold,
      settings.highThreshold,
      settings.unit,
    );
    final low = glucoseFormatter.value(settings.lowThreshold, settings.unit);
    final high = glucoseFormatter.value(settings.highThreshold, settings.unit);
    final veryHigh = glucoseFormatter.value(
      settings.veryHighThreshold,
      settings.unit,
    );
    return TargetRangeProfileViewModel(
      ranges: [
        TargetRangeProfileRowViewModel(
          icon: Icons.stacked_line_chart_rounded,
          label: strings.targetRangePrimaryBandLabel,
          subtitle: strings.targetRangePrimaryBandSubtitle,
          valueLabel: target.fullLabel,
        ),
        TargetRangeProfileRowViewModel(
          icon: Icons.trending_down_rounded,
          label: strings.targetRangeLowThresholdLabel,
          subtitle: strings.targetRangeLowThresholdSubtitle,
          valueLabel: low.fullLabel,
        ),
        TargetRangeProfileRowViewModel(
          icon: Icons.trending_up_rounded,
          label: strings.targetRangeHighThresholdLabel,
          subtitle: strings.targetRangeHighThresholdSubtitle,
          valueLabel: high.fullLabel,
        ),
        TargetRangeProfileRowViewModel(
          icon: Icons.warning_amber_rounded,
          label: strings.targetRangeVeryHighThresholdLabel,
          subtitle: strings.targetRangeVeryHighThresholdSubtitle,
          valueLabel: veryHigh.fullLabel,
        ),
      ],
    );
  }
}
