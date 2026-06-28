import '../../../../domain/status_level.dart';
import '../facts/watch_evidence_bundle.dart';

class WatchTakeawayPolicy {
  const WatchTakeawayPolicy();

  String takeaway({
    required StatusLevel level,
    required WatchEvidenceBundle bundle,
  }) {
    if (level == StatusLevel.healthy) {
      return 'Watch display path has observable evidence.';
    }
    if (bundle.availableCount == 0) {
      return 'Watch display path is not part of the observed setup.';
    }
    return 'Watch display path has partial evidence.';
  }

  String summary({
    required StatusLevel level,
    required WatchEvidenceBundle bundle,
  }) {
    if (bundle.availableCount == 0) {
      return 'No watch bridge evidence was observed. This path is optional.';
    }
    return '${bundle.availableCount} of ${bundle.expectedCount} watch display checks have observable evidence.';
  }
}
