import '../../../domain/probe/status_probe_category.dart';
import '../../../domain/probe/status_probe_history_sample.dart';
import '../../../domain/probe/status_probe_run_mode.dart';
import '../../../domain/probe/status_probe_state.dart';

class StatusProbeSampleRowMapper {
  const StatusProbeSampleRowMapper();

  Map<String, Object?> toRow(StatusProbeHistorySample sample) => {
        'subject_id': sample.subjectId,
        'source_target_id': sample.sourceTargetId,
        'endpoint': sample.probeId,
        'probe_id': sample.probeId,
        'suite_id': sample.suiteId,
        'run_mode': sample.runMode.name,
        'category': sample.category.name,
        'level': sample.state.name,
        'reachable': sample.reachable ? 1 : 0,
        'status_code': sample.statusCode,
        'elapsed_ms': sample.elapsed.inMilliseconds,
        'at_ms': sample.at.millisecondsSinceEpoch,
        'confidence': sample.confidence,
        'summary': sample.summary,
        'payload_json': sample.payloadJson,
      };

  StatusProbeHistorySample fromRow(Map<String, Object?> row) {
    final elapsed = row['elapsed_ms'];
    final probeId =
        row['probe_id']?.toString() ?? row['endpoint']?.toString() ?? '';
    final suiteId = row['suite_id']?.toString() ?? _suiteFromProbeId(probeId);
    return StatusProbeHistorySample(
      subjectId: row['subject_id']?.toString() ?? '',
      sourceTargetId: row['source_target_id']?.toString(),
      probeId: probeId,
      suiteId: suiteId,
      runMode: StatusProbeRunMode.values.firstWhere(
        (mode) => mode.name == row['run_mode']?.toString(),
        orElse: () => StatusProbeRunMode.active,
      ),
      category: StatusProbeCategory.values.firstWhere(
        (category) => category.name == row['category']?.toString(),
        orElse: () => StatusProbeCategory.api,
      ),
      state: StatusProbeState.values.firstWhere(
        (state) => state.name == row['level']?.toString(),
        orElse: () => StatusProbeState.unknown,
      ),
      reachable: row['reachable'] == 1,
      statusCode: row['status_code'] is int ? row['status_code'] as int : null,
      elapsed: Duration(milliseconds: elapsed is int ? elapsed : 0),
      at: DateTime.fromMillisecondsSinceEpoch(row['at_ms'] as int),
      summary: row['summary']?.toString() ?? row['level']?.toString() ?? '',
      confidence:
          row['confidence'] is num ? (row['confidence'] as num).toDouble() : 0,
      payloadJson: row['payload_json']?.toString(),
    );
  }

  String _suiteFromProbeId(String probeId) {
    final dot = probeId.indexOf('.');
    if (dot <= 0) return probeId;
    return probeId.substring(0, dot);
  }
}
