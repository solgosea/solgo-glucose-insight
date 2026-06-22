import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';

class StatusReportCapabilitiesBuilder {
  const StatusReportCapabilitiesBuilder();

  StatusMonitorCapabilitiesPayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    final caps = report.capabilities;
    return StatusMonitorCapabilitiesPayload(
      trailing: caps.modeLabel,
      tiles: [
        _tile(strings.reportCapabilityEntries, caps.entries, strings),
        _tile(
          strings.reportCapabilityRangeQuery,
          caps.entryRangeQuery,
          strings,
        ),
        _tile(strings.reportCapabilityPebble, caps.pebble, strings),
        _tile(
          strings.reportCapabilityUploaderBattery,
          caps.uploaderBattery,
          strings,
        ),
        _tile(
          strings.reportCapabilityDeviceStatus,
          caps.deviceStatus,
          strings,
        ),
        _tile(
          strings.reportCapabilityNightscoutStatus,
          caps.nightscoutStatus,
          strings,
        ),
        _tile(
          strings.reportCapabilityUploadLatency,
          caps.uploadLatency,
          strings,
        ),
        StatusMonitorCapabilityTilePayload(
          label: strings.reportModeLabel,
          value: caps.modeLabel,
          tone: report.hasConfiguredSource ? 'ok' : 'unknown',
        ),
      ],
    );
  }

  StatusMonitorCapabilityTilePayload _tile(
    String label,
    bool available,
    StatusMonitorLocalizations strings,
  ) {
    return StatusMonitorCapabilityTilePayload(
      label: label,
      value: available ? strings.reportAvailable : strings.reportNotExposed,
      tone: available ? 'ok' : 'unknown',
    );
  }
}
