import '../../domain/state/status_observation_state.dart';

class StatusUiStateLabelMapper {
  const StatusUiStateLabelMapper();

  String shortLabel(StatusObservationState state) {
    return switch (state) {
      StatusObservationState.yes => 'Yes',
      StatusObservationState.watch => 'Watch',
      StatusObservationState.no => 'No',
      StatusObservationState.notObserved => 'No',
      StatusObservationState.notConfigured => 'Not configured',
      StatusObservationState.waiting => 'Waiting',
      StatusObservationState.unknown => 'Unknown',
    };
  }
}
