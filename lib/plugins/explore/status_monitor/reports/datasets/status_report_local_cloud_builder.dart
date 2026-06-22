import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_support_facts.dart';

class StatusReportLocalCloudBuilder {
  final StatusReportSupportFactsBuilder factsBuilder;

  const StatusReportLocalCloudBuilder({
    this.factsBuilder = const StatusReportSupportFactsBuilder(),
  });

  StatusMonitorLocalCloudPayload build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    final facts = factsBuilder.build(report, l10n: strings);
    return StatusMonitorLocalCloudPayload(
      trailing: strings.reportFastTriage,
      local: StatusMonitorStreamComparisonPayload(
        title: strings.reportLocalActiveStream,
        role: strings.reportLatestVisibleReading,
        value: facts.localFreshness.value,
        body: _localBody(facts, strings),
        tone: facts.localFreshness.tone,
      ),
      cloud: StatusMonitorStreamComparisonPayload(
        title: strings.reportNightscoutCloud,
        role: strings.reportLatestServerReading,
        value: facts.serverFreshness.value,
        body: _cloudBody(facts, strings),
        tone: facts.serverFreshness.tone,
      ),
      rows: [
        facts.localResponse,
        facts.serverResponse,
        facts.completeness,
        facts.largestGap,
      ],
    );
  }

  String _localBody(
    StatusReportSupportFacts facts,
    StatusMonitorLocalizations strings,
  ) {
    if (facts.localFreshness.value == strings.reportUnknown) {
      return strings.reportLocalFreshnessNotVisible;
    }
    if (facts.localResponse.value == strings.reportUnknown) {
      return strings.reportXdripResponseIncomplete;
    }
    return strings.reportActiveSourceVisible;
  }

  String _cloudBody(
    StatusReportSupportFacts facts,
    StatusMonitorLocalizations strings,
  ) {
    if (facts.serverFreshness.value == strings.reportUnknown) {
      return strings.reportNightscoutFreshnessNotVisible;
    }
    if (facts.serverFreshness.tone == 'watch' ||
        facts.serverFreshness.tone == 'issue') {
      return strings.reportCloudEntriesBehind;
    }
    return strings.reportCloudEntriesCurrent;
  }
}
