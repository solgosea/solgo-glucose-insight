import 'dart:async';

import '../../../domain/probe/status_probe_evidence_bundle.dart';

class StatusProbeEventBus {
  final _controller = StreamController<StatusProbeEvidenceBundle>.broadcast();

  Stream<StatusProbeEvidenceBundle> get stream => _controller.stream;

  void publish(StatusProbeEvidenceBundle bundle) {
    if (!_controller.isClosed) _controller.add(bundle);
  }

  Future<void> dispose() => _controller.close();
}
