import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_evidence_bundle.dart';
import '../contracts/status_probe_history_repository.dart';
import '../policies/status_probe_history_write_policy.dart';
import 'status_probe_history_sample_mapper.dart';

class StatusProbeHistoryRecorder {
  final StatusProbeHistoryRepository repository;
  final StatusProbeHistoryWritePolicy writePolicy;
  final StatusProbeHistorySampleMapper mapper;

  const StatusProbeHistoryRecorder({
    required this.repository,
    this.writePolicy = const StatusProbeHistoryWritePolicy(),
    this.mapper = const StatusProbeHistorySampleMapper(),
  });

  Future<void> record({
    required StatusProbeContext context,
    required StatusProbeEvidenceBundle bundle,
  }) async {
    for (final suite in bundle.suites) {
      for (final result in suite.results) {
        if (!writePolicy.shouldWrite(result)) continue;
        await repository.save(mapper.map(context, result));
      }
    }
  }
}
