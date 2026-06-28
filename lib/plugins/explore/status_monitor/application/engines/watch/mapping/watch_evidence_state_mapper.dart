import '../../../../domain/component_evidence/status_component_evidence_source_ref.dart';
import '../../../../domain/component_evidence/status_component_evidence_state.dart';
import '../../../../domain/status_level.dart';

class WatchEvidenceStateMapper {
  const WatchEvidenceStateMapper();

  StatusLevel level(StatusComponentEvidenceState state) {
    return switch (state) {
      StatusComponentEvidenceState.healthy => StatusLevel.healthy,
      StatusComponentEvidenceState.watch => StatusLevel.watch,
      StatusComponentEvidenceState.issue => StatusLevel.issue,
      StatusComponentEvidenceState.notObserved ||
      StatusComponentEvidenceState.notConfigured ||
      StatusComponentEvidenceState.unknown =>
        StatusLevel.unknown,
    };
  }

  String displayValue(StatusComponentEvidenceState state) {
    return switch (state) {
      StatusComponentEvidenceState.healthy => 'Yes',
      StatusComponentEvidenceState.watch => 'Watch',
      StatusComponentEvidenceState.issue => 'No',
      StatusComponentEvidenceState.notObserved => 'No',
      StatusComponentEvidenceState.notConfigured => 'Not configured',
      StatusComponentEvidenceState.unknown => 'Unknown',
    };
  }

  String sourceLabel(StatusComponentEvidenceSourceRef source) {
    if (source.path != null && source.path!.isNotEmpty) {
      return '${source.source} 路 ${source.path}';
    }
    return source.source;
  }
}
