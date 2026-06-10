import 'dart:async';

import '../../domain/event/alert_event.dart';

class AlertOverlaySignalBus {
  final _controller = StreamController<AlertEvent>.broadcast();

  Stream<AlertEvent> get events => _controller.stream;

  void show(AlertEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
