import '../../domain/subject/analysis_subject.dart';

class AnalysisSessionSnapshotSummary {
  final AnalysisSubject activeSubject;
  final int readingsCount;
  final int eventsCount;
  final int dailySummaryCount;
  final int periodSummaryCount;
  final DateTime? generatedAt;
  final bool hasConfiguredSource;

  const AnalysisSessionSnapshotSummary({
    required this.activeSubject,
    required this.readingsCount,
    required this.eventsCount,
    required this.dailySummaryCount,
    required this.periodSummaryCount,
    required this.generatedAt,
    required this.hasConfiguredSource,
  });

  bool get hasGlucoseData => readingsCount > 0;

  bool get hasGlucoseEvents => eventsCount > 0;

  bool get hasDailySummaries => dailySummaryCount > 0;

  bool get hasPeriodSummaries => periodSummaryCount > 0;
}
