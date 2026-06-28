class StatusProbeScenarioScoreBreakdown {
  final int coreScore;
  final int corePassing;
  final int coreTotal;
  final int coreNeedsAction;
  final int optionalActive;
  final int optionalTotal;
  final List<String> appliedGateProbeIds;
  final List<String> appliedCapProbeIds;

  const StatusProbeScenarioScoreBreakdown({
    required this.coreScore,
    required this.corePassing,
    required this.coreTotal,
    required this.coreNeedsAction,
    required this.optionalActive,
    required this.optionalTotal,
    this.appliedGateProbeIds = const [],
    this.appliedCapProbeIds = const [],
  });

  double get coreProgress => coreTotal == 0 ? 0 : corePassing / coreTotal;
}
