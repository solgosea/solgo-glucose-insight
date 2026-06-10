import '../../domain/resource/alert_sound_ref.dart';
import '../../infrastructure/audio/alert_audio_gateway.dart';

class AlertSoundPreviewService {
  final AlertAudioGateway gateway;

  const AlertSoundPreviewService({this.gateway = const AlertAudioGateway()});

  Future<void> preview(AlertSoundRef sound) => gateway.preview(sound);
}
