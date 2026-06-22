import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../application/i18n/status_monitor_status_level_localizer.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_component_l10n.dart';
import 'status_report_privacy_sanitizer.dart';

class StatusReportChainBuilder {
  final StatusReportPrivacySanitizer sanitizer;

  const StatusReportChainBuilder({
    this.sanitizer = const StatusReportPrivacySanitizer(),
  });

  StatusMonitorChainPayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    const order = [
      StatusComponentKind.cgmSensor,
      StatusComponentKind.xdrip,
      StatusComponentKind.nightscout,
      StatusComponentKind.aapsLoop,
    ];
    return StatusMonitorChainPayload(
      trailing: sanitizer.text(
        report.capabilities.modeLabel,
        replacement: strings.reportConfiguredSource,
      ),
      nodes: [
        for (final kind in order)
          _node(report.components.firstWhere((c) => c.kind == kind), strings),
      ],
    );
  }

  StatusMonitorChainNodePayload _node(
    component,
    StatusMonitorLocalizations strings,
  ) {
    return StatusMonitorChainNodePayload(
      title: statusReportComponentTitle(component.kind, strings),
      role: statusReportComponentRole(component.kind, strings),
      state: statusMonitorLevelLabel(component.level, strings),
      body: sanitizer.text(
        statusReportComponentTakeaway(component, strings),
        replacement: strings.reportConfiguredSource,
      ),
      tone: _tone(component.level),
    );
  }

  String _tone(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => 'ok',
      StatusLevel.watch => 'watch',
      StatusLevel.issue => 'issue',
      StatusLevel.unknown => 'unknown',
    };
  }
}
