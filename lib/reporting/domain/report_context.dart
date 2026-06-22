import 'dart:ui';

import 'package:smart_xdrip/domain/entities/app_settings.dart';

import 'report_date_range.dart';
import 'report_privacy_level.dart';

class ReportContext {
  final ReportDateRange range;
  final GlucoseUnit unit;
  final ReportPrivacyLevel privacyLevel;
  final String? sourceLabel;
  final Locale locale;
  final Map<String, Object?> options;

  const ReportContext({
    required this.range,
    required this.unit,
    required this.privacyLevel,
    required this.locale,
    this.sourceLabel,
    this.options = const {},
  });
}
