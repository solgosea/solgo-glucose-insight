import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../analyzers/profile_summary_analyzer.dart';
import '../application/i18n/profile_l10n_resolver.dart';
import '../l10n/generated/profile_localizations.dart';
import '../models/profile_view_model.dart';

class ProfileViewModelMapper {
  final ProfileSummaryAnalyzer analyzer;
  final GlucoseUnitFormatService glucoseFormatter;

  const ProfileViewModelMapper({
    this.analyzer = const ProfileSummaryAnalyzer(),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  ProfileViewModel map({
    required AnalysisFacade facade,
    required AppSettings settings,
    ProfileLocalizations? l10n,
  }) {
    final strings = l10n ?? ProfileL10nResolver.fallback;
    final result = analyzer.analyze(facade: facade);
    final average14d = glucoseFormatter.value(result.average14d, settings.unit);
    return ProfileViewModel(
      header: ProfileHeaderViewModel(
        title: strings.profileHeaderTitle,
        primaryBadge: strings.profileDaysRecorded(14),
      ),
      stats: [
        ProfileStatViewModel(
          value: result.tir14d.toStringAsFixed(0),
          unit: '%',
          label: strings.profileStatTir14d,
          valueColor: _tirColor(result.tir14d),
        ),
        ProfileStatViewModel(
          value: average14d.valueLabel,
          unit: average14d.unitLabel,
          label: strings.profileStatAvg14d,
          valueColor: AppColors.text,
        ),
        ProfileStatViewModel(
          value: result.cv14d.toStringAsFixed(0),
          unit: '%',
          label: strings.profileStatCv14d,
          valueColor: _cvColor(result.cv14d),
        ),
      ],
      appSettingsSummary: strings.profileSettingsSummary,
    );
  }

  Color _tirColor(double value) {
    return value >= 70 ? AppColors.text : AppColors.amber;
  }

  Color _cvColor(double value) {
    if (value <= 30) return AppColors.green;
    if (value <= 36) return AppColors.text;
    return AppColors.amber;
  }
}
