import '../../domain/probe/status_probe_state.dart';
import '../../domain/state/status_observation_label.dart';
import '../../domain/state/status_observation_mapping_result.dart';
import '../../domain/state/status_observation_severity.dart';
import '../../domain/state/status_observation_state.dart';

class StatusProbeStateObservationMapper {
  const StatusProbeStateObservationMapper();

  StatusObservationMappingResult map(StatusProbeState state) {
    return switch (state) {
      StatusProbeState.healthy => const StatusObservationMappingResult(
          state: StatusObservationState.yes,
          severity: StatusObservationSeverity.good,
          label: StatusObservationLabel(
            shortLabel: 'Yes',
            longLabel: 'Evidence observed',
          ),
        ),
      StatusProbeState.watch => const StatusObservationMappingResult(
          state: StatusObservationState.watch,
          severity: StatusObservationSeverity.attention,
          label: StatusObservationLabel(
            shortLabel: 'Watch',
            longLabel: 'Partial evidence',
          ),
        ),
      StatusProbeState.issue => const StatusObservationMappingResult(
          state: StatusObservationState.no,
          severity: StatusObservationSeverity.blocked,
          label: StatusObservationLabel(
            shortLabel: 'No',
            longLabel: 'Issue observed',
          ),
        ),
      StatusProbeState.notObserved => const StatusObservationMappingResult(
          state: StatusObservationState.notObserved,
          severity: StatusObservationSeverity.neutral,
          label: StatusObservationLabel(
            shortLabel: 'No',
            longLabel: 'Not observed',
          ),
        ),
      StatusProbeState.notConfigured => const StatusObservationMappingResult(
          state: StatusObservationState.notConfigured,
          severity: StatusObservationSeverity.neutral,
          label: StatusObservationLabel(
            shortLabel: 'Not configured',
            longLabel: 'Not configured',
          ),
        ),
      StatusProbeState.waiting => const StatusObservationMappingResult(
          state: StatusObservationState.waiting,
          severity: StatusObservationSeverity.neutral,
          label: StatusObservationLabel(
            shortLabel: 'Waiting',
            longLabel: 'Waiting for evidence',
          ),
        ),
      StatusProbeState.unknown => const StatusObservationMappingResult(
          state: StatusObservationState.unknown,
          severity: StatusObservationSeverity.neutral,
          label: StatusObservationLabel(
            shortLabel: 'Unknown',
            longLabel: 'Unknown',
          ),
        ),
    };
  }
}
