import '../../../domain/analysis/status_analysis_context.dart';

class NightscoutServerFreshnessCalculator {
  const NightscoutServerFreshnessCalculator();

  String latestLabel(StatusAnalysisContext context) {
    final readings = context.evidence.nightscoutEvidence.readings;
    if (readings.isEmpty) return 'No server reading';
    final age = context.now.difference(readings.last.timestamp);
    if (age.inMinutes < 1) return '0s';
    return '${age.inMinutes}m';
  }
}
