import 'dart:async';

import 'plugin_runtime_event.dart';

class PluginRuntimeEventBus {
  final StreamController<PluginRuntimeEvent> _controller =
      StreamController<PluginRuntimeEvent>.broadcast();

  Stream<PluginRuntimeEvent> get events => _controller.stream;

  void publish(PluginRuntimeEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
