import '../../../domain/probe/status_probe_history_sample.dart';

abstract interface class StatusProbeHistoryRepository {
  Future<void> save(StatusProbeHistorySample sample);

  Future<List<StatusProbeHistorySample>> latest({
    required String subjectId,
    required String probeId,
    int limit,
  });
}
