import 'package:vibration/vibration.dart';

import '../../domain/resource/alert_vibration_pattern.dart';

class AlertVibrationGateway {
  const AlertVibrationGateway();

  Future<bool> get hasVibrator async => Vibration.hasVibrator();

  Future<void> vibrate(AlertVibrationPattern pattern) async {
    if (!await hasVibrator) return;
    await Vibration.vibrate(pattern: pattern.pattern);
  }

  Future<void> cancel() {
    return Vibration.cancel();
  }
}
