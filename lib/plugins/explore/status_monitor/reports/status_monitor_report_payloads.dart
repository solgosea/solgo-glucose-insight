class StatusMonitorReportHeroPayload {
  final String eyebrow;
  final String title;
  final String summary;

  const StatusMonitorReportHeroPayload({
    required this.eyebrow,
    required this.title,
    required this.summary,
  });
}

class StatusMonitorReportMetaPayload {
  final String windowTitle;
  final String windowLabel;
  final String sourceModeTitle;
  final String sourceMode;
  final String generatedTitle;
  final String generatedLabel;
  final String privacyTitle;
  final String privacyLabel;

  const StatusMonitorReportMetaPayload({
    required this.windowTitle,
    required this.windowLabel,
    required this.sourceModeTitle,
    required this.sourceMode,
    required this.generatedTitle,
    required this.generatedLabel,
    required this.privacyTitle,
    required this.privacyLabel,
  });
}

class StatusMonitorScorePayload {
  final String value;
  final String label;
  final String body;
  final String tone;

  const StatusMonitorScorePayload({
    required this.value,
    required this.label,
    required this.body,
    required this.tone,
  });
}

class StatusMonitorSupportTriagePayload {
  final String label;
  final String title;
  final String body;
  final String evidenceScoreTitle;
  final String communityCopyTitle;
  final String privacySafeLabel;
  final List<StatusMonitorSupportReasonPayload> reasons;
  final StatusMonitorScorePayload evidenceScore;
  final StatusMonitorCommunitySummaryPayload communityCopy;

  const StatusMonitorSupportTriagePayload({
    required this.label,
    required this.title,
    required this.body,
    required this.evidenceScoreTitle,
    required this.communityCopyTitle,
    required this.privacySafeLabel,
    required this.reasons,
    required this.evidenceScore,
    required this.communityCopy,
  });
}

class StatusMonitorSupportReasonPayload {
  final String title;
  final String body;
  final String tone;

  const StatusMonitorSupportReasonPayload({
    required this.title,
    required this.body,
    required this.tone,
  });
}

class StatusMonitorLocalCloudPayload {
  final String trailing;
  final StatusMonitorStreamComparisonPayload local;
  final StatusMonitorStreamComparisonPayload cloud;
  final List<StatusMonitorProbeRowPayload> rows;

  const StatusMonitorLocalCloudPayload({
    required this.trailing,
    required this.local,
    required this.cloud,
    required this.rows,
  });
}

class StatusMonitorStreamComparisonPayload {
  final String title;
  final String role;
  final String value;
  final String body;
  final String tone;

  const StatusMonitorStreamComparisonPayload({
    required this.title,
    required this.role,
    required this.value,
    required this.body,
    required this.tone,
  });
}

class StatusMonitorChainPayload {
  final String trailing;
  final List<StatusMonitorChainNodePayload> nodes;

  const StatusMonitorChainPayload({
    required this.trailing,
    required this.nodes,
  });
}

class StatusMonitorChainNodePayload {
  final String title;
  final String role;
  final String state;
  final String body;
  final String tone;

  const StatusMonitorChainNodePayload({
    required this.title,
    required this.role,
    required this.state,
    required this.body,
    required this.tone,
  });
}

class StatusMonitorComponentEvidencePayload {
  final List<StatusMonitorComponentRowPayload> rows;
  final String componentTitle;
  final String statusTitle;
  final String takeawayTitle;
  final String checksTitle;
  final String evidenceTitle;

  const StatusMonitorComponentEvidencePayload({
    required this.rows,
    this.componentTitle = 'COMPONENT',
    this.statusTitle = 'STATUS',
    this.takeawayTitle = 'TAKEAWAY',
    this.checksTitle = 'CHECKS',
    this.evidenceTitle = 'USEFUL EVIDENCE',
  });
}

class StatusMonitorComponentRowPayload {
  final String component;
  final String role;
  final String status;
  final String tone;
  final String takeaway;
  final String checks;
  final String evidence;

  const StatusMonitorComponentRowPayload({
    required this.component,
    required this.role,
    required this.status,
    required this.tone,
    required this.takeaway,
    required this.checks,
    required this.evidence,
  });
}

class StatusMonitorCapabilitiesPayload {
  final String trailing;
  final List<StatusMonitorCapabilityTilePayload> tiles;

  const StatusMonitorCapabilitiesPayload({
    required this.trailing,
    required this.tiles,
  });
}

class StatusMonitorCapabilityTilePayload {
  final String label;
  final String value;
  final String tone;

  const StatusMonitorCapabilityTilePayload({
    required this.label,
    required this.value,
    required this.tone,
  });
}

class StatusMonitorFreshnessPayload {
  final String trailing;
  final String currentLegendLabel;
  final String partialLegendLabel;
  final String gapLegendLabel;
  final List<StatusMonitorTimelineTickPayload> ticks;
  final List<StatusMonitorProbeRowPayload> rows;

  const StatusMonitorFreshnessPayload({
    required this.trailing,
    required this.currentLegendLabel,
    required this.partialLegendLabel,
    required this.gapLegendLabel,
    required this.ticks,
    required this.rows,
  });
}

class StatusMonitorTimelineTickPayload {
  final String tone;

  const StatusMonitorTimelineTickPayload({required this.tone});
}

class StatusMonitorProbeRowPayload {
  final String label;
  final String value;
  final String tone;

  const StatusMonitorProbeRowPayload({
    required this.label,
    required this.value,
    required this.tone,
  });
}

class StatusMonitorTechnicalEvidencePayload {
  final String observedTitle;
  final String limitsTitle;
  final List<String> observedFacts;
  final List<String> limits;

  const StatusMonitorTechnicalEvidencePayload({
    required this.observedTitle,
    required this.limitsTitle,
    required this.observedFacts,
    required this.limits,
  });
}

class StatusMonitorCommunitySummaryPayload {
  final String text;

  const StatusMonitorCommunitySummaryPayload({required this.text});
}

class StatusMonitorFirstLookPayload {
  final List<StatusMonitorFindingPayload> findings;

  const StatusMonitorFirstLookPayload({required this.findings});
}

class StatusMonitorFindingPayload {
  final String title;
  final String body;
  final String tone;

  const StatusMonitorFindingPayload({
    required this.title,
    required this.body,
    required this.tone,
  });
}
