import 'dart:async';

import '../../domain/actuator/alert_actuator_command.dart';

class AlertActuatorCommandQueue {
  final StreamController<AlertActuatorCommand> _controller =
      StreamController<AlertActuatorCommand>.broadcast();

  Stream<AlertActuatorCommand> get commands => _controller.stream;

  void publish(AlertActuatorCommand command) {
    if (!_controller.isClosed) {
      _controller.add(command);
    }
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
