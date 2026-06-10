import '../../domain/resource/alert_builtin_sounds.dart';
import '../../domain/resource/alert_sound_ref.dart';

class AlertSoundCatalog {
  const AlertSoundCatalog();

  List<AlertSoundRef> builtInSounds() => AlertBuiltinSounds.all;

  List<AlertSoundRef> quietSounds() => const [AlertSoundRef.silent()];
}
