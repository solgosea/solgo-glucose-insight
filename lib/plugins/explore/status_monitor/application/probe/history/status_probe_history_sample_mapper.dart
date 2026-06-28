import 'dart:convert';

import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_history_sample.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_state.dart';

class StatusProbeHistorySampleMapper {
  const StatusProbeHistorySampleMapper();

  StatusProbeHistorySample map(
    StatusProbeContext context,
    StatusProbeResult result,
  ) {
    return StatusProbeHistorySample(
      subjectId: context.subjectId,
      sourceTargetId: context.target.targetId,
      probeId: result.probeId,
      suiteId: result.suiteId,
      runMode: result.runMode,
      category: result.definition.category,
      state: result.state,
      reachable: _isReachable(result.state),
      statusCode: _statusCode(result),
      elapsed: result.elapsed ?? Duration.zero,
      at: result.observedAt,
      summary: result.summary,
      confidence: result.confidence,
      payloadJson: jsonEncode(result.toJson()),
    );
  }

  bool _isReachable(StatusProbeState state) {
    return switch (state) {
      StatusProbeState.healthy || StatusProbeState.watch => true,
      StatusProbeState.issue ||
      StatusProbeState.unknown ||
      StatusProbeState.waiting ||
      StatusProbeState.notObserved ||
      StatusProbeState.notConfigured =>
        false,
    };
  }

  int? _statusCode(StatusProbeResult result) {
    for (final evidence in result.evidence) {
      final value = evidence.metadata['statusCode'];
      if (value is int) return value;
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return null;
  }
}
