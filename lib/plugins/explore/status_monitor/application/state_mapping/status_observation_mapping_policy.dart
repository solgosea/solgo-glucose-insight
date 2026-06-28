import '../../domain/probe/status_probe_state.dart';
import '../../domain/state/status_observation_mapping_result.dart';
import 'status_probe_state_observation_mapper.dart';

class StatusObservationMappingPolicy {
  final StatusProbeStateObservationMapper probeMapper;

  const StatusObservationMappingPolicy({
    this.probeMapper = const StatusProbeStateObservationMapper(),
  });

  StatusObservationMappingResult fromProbeState(StatusProbeState state) {
    return probeMapper.map(state);
  }
}
