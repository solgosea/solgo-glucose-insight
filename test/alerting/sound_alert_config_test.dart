import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/domain/config/sound_alert_config.dart';
import 'package:smart_xdrip/alerting/domain/resource/alert_builtin_sounds.dart';
import 'package:smart_xdrip/alerting/domain/resource/alert_sound_ref.dart';

void main() {
  test('SoundAlertConfig defaults to built-in urgent pulse', () {
    const config = SoundAlertConfig();

    expect(config.sound.source, AlertSoundSource.asset);
    expect(config.sound.uri, AlertBuiltinSounds.urgentPulse.uri);
    expect(
      config.sound.displayName,
      AlertBuiltinSounds.urgentPulse.displayName,
    );

    final restored = SoundAlertConfig.fromJson(const {});

    expect(restored.sound.source, AlertSoundSource.asset);
    expect(restored.sound.uri, AlertBuiltinSounds.urgentPulse.uri);
    expect(
      restored.sound.displayName,
      AlertBuiltinSounds.urgentPulse.displayName,
    );
  });

  test('SoundAlertConfig preserves selected custom file sound', () {
    const config = SoundAlertConfig(
      sound: AlertSoundRef.file(
        uri: '/app/alert_sounds/custom.wav',
        displayName: 'Custom pulse',
      ),
      repeatCritical: false,
      maxDurationSeconds: 30,
    );

    final restored = SoundAlertConfig.fromJson(config.toJson());

    expect(restored.sound.source, AlertSoundSource.file);
    expect(restored.sound.uri, '/app/alert_sounds/custom.wav');
    expect(restored.sound.displayName, 'Custom pulse');
    expect(restored.repeatCritical, isFalse);
    expect(restored.maxDurationSeconds, 30);
  });
}
