import '../../../domain/probe/status_probe_history_sample.dart';
import '../contracts/status_probe_history_repository.dart';

class StatusProbeHistoryQueryService {
  final StatusProbeHistoryRepository repository;

  const StatusProbeHistoryQueryService({
    required this.repository,
  });

  Future<List<StatusProbeHistorySample>> latest({
    required String subjectId,
    required String probeId,
    int limit = 20,
  }) {
    return repository.latest(
      subjectId: subjectId,
      probeId: probeId,
      limit: limit,
    );
  }
}
