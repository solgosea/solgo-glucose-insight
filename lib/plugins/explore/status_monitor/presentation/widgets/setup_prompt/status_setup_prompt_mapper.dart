import 'package:flutter/material.dart';

import '../../styles/status_monitor_theme.dart';
import '../../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../../domain/status_report.dart';
import '../../../l10n/generated/status_monitor_localizations.dart';
import 'status_setup_prompt_model.dart';

class StatusSetupPromptMapper {
  final StatusMonitorLocalizations? l10n;

  const StatusSetupPromptMapper({this.l10n});

  StatusMonitorLocalizations get _strings =>
      l10n ?? StatusMonitorL10nResolver.fallback;

  StatusSetupPromptModel? map(StatusReport report) {
    if (report.hasConfiguredSource) return null;
    return StatusSetupPromptModel(
      icon: Icons.cloud_queue_rounded,
      accentColor: StatusMonitorTheme.blue,
      title: _strings.pageConnectNightscout,
      body: _strings.pageSetupSourceBody,
      actionLabel: _strings.pageSetUp,
    );
  }
}
