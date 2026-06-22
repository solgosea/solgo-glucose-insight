import '../../domain/component_health.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../domain/status_metric.dart';
import '../../domain/status_report.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../status_monitor_report_payloads.dart';
import 'status_report_component_l10n.dart';
import 'status_report_privacy_sanitizer.dart';

class StatusReportSupportFacts {
  final String sourceMode;
  final String issuePhrase;
  final String supportTakeaway;
  final StatusMonitorProbeRowPayload localFreshness;
  final StatusMonitorProbeRowPayload serverFreshness;
  final StatusMonitorProbeRowPayload localResponse;
  final StatusMonitorProbeRowPayload serverResponse;
  final StatusMonitorProbeRowPayload completeness;
  final StatusMonitorProbeRowPayload largestGap;
  final StatusMonitorProbeRowPayload aapsEvidence;
  final String firstLookTitle;
  final String firstLookBody;
  final String firstLookTone;

  const StatusReportSupportFacts({
    required this.sourceMode,
    required this.issuePhrase,
    required this.supportTakeaway,
    required this.localFreshness,
    required this.serverFreshness,
    required this.localResponse,
    required this.serverResponse,
    required this.completeness,
    required this.largestGap,
    required this.aapsEvidence,
    required this.firstLookTitle,
    required this.firstLookBody,
    required this.firstLookTone,
  });
}

class StatusReportSupportFactsBuilder {
  final StatusReportPrivacySanitizer sanitizer;

  const StatusReportSupportFactsBuilder({
    this.sanitizer = const StatusReportPrivacySanitizer(),
  });

  StatusReportSupportFacts build(
    StatusReport report, {
    StatusMonitorLocalizations? l10n,
  }) {
    final strings = l10n ?? StatusMonitorL10nResolver.fallback;
    final cgm = _component(report, StatusComponentKind.cgmSensor, strings);
    final xdrip = _component(report, StatusComponentKind.xdrip, strings);
    final nightscout = _component(
      report,
      StatusComponentKind.nightscout,
      strings,
    );
    final aaps = _component(report, StatusComponentKind.aapsLoop, strings);
    final localFreshness = _row(
      strings.reportLatestLocalReading,
      _metric(xdrip, const ['freshness']) ??
          _metric(cgm, const ['sensor_freshness']),
      strings,
    );
    final serverFreshness = _row(
      strings.reportLatestNightscoutReading,
      _metric(nightscout, const ['server_data_freshness']),
      strings,
    );
    final localResponse = _row(
      strings.reportXdripLocalResponse,
      _metric(xdrip, const ['local_service']),
      strings,
    );
    final serverResponse = _row(
      strings.reportNightscoutResponse,
      _metric(nightscout, const ['response_time', 'api_reachable']),
      strings,
    );
    final completeness = _row(
      strings.reportCompleteness24h,
      _metric(xdrip, const ['completeness_24h']),
      strings,
    );
    final largestGap = _row(
      strings.reportLargestVisibleGap,
      _metric(cgm, const ['signal_continuity']),
      strings,
    );
    final aapsEvidence = _row(
      strings.reportAapsEvidence,
      _metric(aaps, const [
        'loop_context',
        'sync_freshness',
        'iob_cob_context',
        'pump_context',
      ]),
      strings,
    );
    final firstLook = _firstLook(
      report: report,
      cgm: cgm,
      xdrip: xdrip,
      nightscout: nightscout,
      aaps: aaps,
      localFreshness: localFreshness,
      serverFreshness: serverFreshness,
      localResponse: localResponse,
      serverResponse: serverResponse,
      strings: strings,
    );
    return StatusReportSupportFacts(
      sourceMode: sanitizer.text(
        report.capabilities.modeLabel,
        replacement: strings.reportConfiguredSource,
      ),
      issuePhrase: _issuePhrase(report, strings),
      supportTakeaway: firstLook.takeaway,
      localFreshness: localFreshness,
      serverFreshness: serverFreshness,
      localResponse: localResponse,
      serverResponse: serverResponse,
      completeness: completeness,
      largestGap: largestGap,
      aapsEvidence: aapsEvidence,
      firstLookTitle: firstLook.title,
      firstLookBody: firstLook.body,
      firstLookTone: firstLook.tone,
    );
  }

  ComponentHealth _component(
    StatusReport report,
    StatusComponentKind kind,
    StatusMonitorLocalizations strings,
  ) {
    return report.components.firstWhere(
      (component) => component.kind == kind,
      orElse: () => ComponentHealth(
        kind: kind,
        level: StatusLevel.unknown,
        title: statusReportComponentTitle(kind, strings),
        role: statusReportComponentRole(kind, strings),
        takeaway: strings.reportNoShareableEvidence,
        summary: strings.reportNoEvidence,
        metrics: const [],
      ),
    );
  }

  StatusMetric? _metric(ComponentHealth component, List<String> ids) {
    for (final id in ids) {
      for (final metric in component.metrics) {
        if (metric.id == id) return metric;
      }
    }
    return null;
  }

  StatusMonitorProbeRowPayload _row(
    String label,
    StatusMetric? metric,
    StatusMonitorLocalizations strings,
  ) {
    if (metric == null) {
      return StatusMonitorProbeRowPayload(
        label: label,
        value: strings.reportUnknown,
        tone: 'unknown',
      );
    }
    final value = sanitizer.text(
      _valueWithContext(metric, strings),
      replacement: strings.reportConfiguredSource,
    );
    return StatusMonitorProbeRowPayload(
      label: label,
      value: value,
      tone: _tone(metric.level),
    );
  }

  String _valueWithContext(
    StatusMetric metric,
    StatusMonitorLocalizations strings,
  ) {
    final note = sanitizer.text(
      metric.note ?? '',
      replacement: strings.reportConfiguredSource,
    );
    if (metric.id == 'completeness_24h' && note.contains('/')) {
      final count = RegExp(r'\d+\s*/\s*\d+').firstMatch(note)?.group(0);
      if (count != null) {
        final parts = count.split('/');
        final observed = int.tryParse(parts.first.trim());
        final expected = int.tryParse(parts.last.trim());
        if (observed != null && expected != null && expected > 0) {
          if (observed >= expected) {
            return strings.reportMeetsExpected(metric.valueLabel, expected);
          }
          return strings.reportObservedExpected(
            metric.valueLabel,
            observed,
            expected,
          );
        }
      }
    }
    if (metric.id == 'signal_continuity') {
      final gaps = metric.metadata['gapsOver15m'];
      if (gaps is num && gaps > 0) {
        return strings.reportGapsOver15m(metric.valueLabel, gaps);
      }
    }
    return metric.valueLabel;
  }

  _FirstLook _firstLook({
    required StatusReport report,
    required ComponentHealth cgm,
    required ComponentHealth xdrip,
    required ComponentHealth nightscout,
    required ComponentHealth aaps,
    required StatusMonitorProbeRowPayload localFreshness,
    required StatusMonitorProbeRowPayload serverFreshness,
    required StatusMonitorProbeRowPayload localResponse,
    required StatusMonitorProbeRowPayload serverResponse,
    required StatusMonitorLocalizations strings,
  }) {
    if (!report.hasConfiguredSource) {
      return _FirstLook(
        title: strings.reportConfigureCgmSource,
        body: strings.reportConfigureCgmSourceBody,
        takeaway: strings.reportConfigureCgmSourceTakeaway,
        tone: 'unknown',
      );
    }

    final localOk = localFreshness.tone == 'ok' || localResponse.tone == 'ok';
    final cloudDelayed =
        serverFreshness.tone == 'watch' || serverFreshness.tone == 'issue';
    final cloudReachable =
        serverResponse.tone == 'ok' || serverResponse.value.contains('OK');
    if (localOk && cloudDelayed) {
      final path = cloudReachable
          ? strings.reportUploadServerDelayPath
          : strings.reportCloudApiPath;
      return _FirstLook(
        title: strings.reportStartWithPath(path),
        body: strings.reportLocalFresherThanCloudBody,
        takeaway: strings.reportLocalFresherThanCloudTakeaway(path),
        tone: 'watch',
      );
    }

    if (cgm.level == StatusLevel.issue || xdrip.level == StatusLevel.issue) {
      final component = cgm.level == StatusLevel.issue ? cgm : xdrip;
      final title = statusReportComponentTitle(component.kind, strings);
      return _FirstLook(
        title: strings.reportStartWithComponent(title),
        body: strings.reportComponentStrongestIssueTakeaway(
          title,
        ),
        takeaway: strings.reportComponentStrongestIssueTakeaway(
          title,
        ),
        tone: _tone(component.level),
      );
    }

    if (nightscout.level == StatusLevel.issue ||
        nightscout.level == StatusLevel.watch) {
      return _FirstLook(
        title: strings.reportStartWithNightscout,
        body: strings.reportNightscoutFirstTakeaway,
        takeaway: strings.reportNightscoutFirstTakeaway,
        tone: _tone(nightscout.level),
      );
    }

    if (aaps.level == StatusLevel.unknown &&
        [cgm, xdrip, nightscout]
            .every((component) => component.level == StatusLevel.healthy)) {
      return _FirstLook(
        title: strings.reportAapsContextLimited,
        body: strings.reportAapsContextLimitedBody,
        takeaway: strings.reportAapsContextLimitedTakeaway,
        tone: 'unknown',
      );
    }

    final priority = [...report.components]
      ..sort((a, b) => b.level.severity.compareTo(a.level.severity));
    final first = priority.first;
    if (first.level == StatusLevel.watch || first.level == StatusLevel.issue) {
      final affected = report.components
          .where((component) =>
              component.level == StatusLevel.watch ||
              component.level == StatusLevel.issue)
          .map((component) =>
              statusReportComponentTitle(component.kind, strings))
          .toList();
      final firstTitle = statusReportComponentTitle(first.kind, strings);
      final affectedLabel = affected.length <= 1
          ? firstTitle
          : affected.length > 2
              ? strings.reportComponentPairAndOthers(
                  affected[0],
                  affected[1],
                  strings.reportAndOthers,
                )
              : strings.reportComponentPair(affected[0], affected[1]);
      return _FirstLook(
        title: strings.reportStartWithComponent(firstTitle),
        body: strings.reportAffectedComponentsTakeaway(
          affectedLabel,
          affected.length == 1 ? strings.reportVerbIs : strings.reportVerbAre,
          firstTitle,
        ),
        takeaway: strings.reportAffectedComponentsTakeaway(
          affectedLabel,
          affected.length == 1 ? strings.reportVerbIs : strings.reportVerbAre,
          firstTitle,
        ),
        tone: _tone(first.level),
      );
    }
    final firstTitle = statusReportComponentTitle(first.kind, strings);
    return _FirstLook(
      title: first.level == StatusLevel.healthy
          ? strings.reportNoMajorStatusIssue
          : strings.reportStartWithComponent(firstTitle),
      body: first.level == StatusLevel.healthy
          ? strings.reportNoMajorStatusIssueBody
          : strings.reportStartWithComponent(firstTitle),
      takeaway: first.level == StatusLevel.healthy
          ? strings.reportNoMajorStatusIssueBody
          : strings.reportStartWithComponent(firstTitle),
      tone: _tone(first.level),
    );
  }

  String _issuePhrase(
    StatusReport report,
    StatusMonitorLocalizations strings,
  ) {
    final issue = report.components
        .where((c) => c.level == StatusLevel.issue)
        .map((c) => statusReportComponentTitle(c.kind, strings))
        .toList();
    if (issue.isNotEmpty) return strings.reportIssuePhraseIssue(issue.first);
    final watch = report.components
        .where((c) => c.level == StatusLevel.watch)
        .map((c) => statusReportComponentTitle(c.kind, strings))
        .toList();
    if (watch.isNotEmpty) return strings.reportIssuePhraseWatch(watch.first);
    if (!report.hasConfiguredSource) {
      return strings.reportNoDataSourceConfigured;
    }
    return strings.reportNoMajorStatusIssue;
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

class _FirstLook {
  final String title;
  final String body;
  final String takeaway;
  final String tone;

  const _FirstLook({
    required this.title,
    required this.body,
    required this.takeaway,
    required this.tone,
  });
}
