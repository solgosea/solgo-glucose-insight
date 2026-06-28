import 'dart:async';

import 'glucose_sync_scheduler_event.dart';

class GlucoseSyncSchedulerEventBus {
  final StreamController<GlucoseSyncSchedulerEvent> _controller =
      StreamController<GlucoseSyncSchedulerEvent>.broadcast();

  Stream<GlucoseSyncSchedulerEvent> get events => _controller.stream;

  void publish(GlucoseSyncSchedulerEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  Future<void> dispose() => _controller.close();
}
