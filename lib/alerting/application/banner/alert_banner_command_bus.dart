import 'dart:async';

import 'alert_banner_command.dart';

class AlertBannerCommandBus {
  final StreamController<AlertBannerCommand> _controller =
      StreamController<AlertBannerCommand>.broadcast();

  Stream<AlertBannerCommand> get commands => _controller.stream;

  void publish(AlertBannerCommand command) {
    if (_controller.isClosed) return;
    _controller.add(command);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
