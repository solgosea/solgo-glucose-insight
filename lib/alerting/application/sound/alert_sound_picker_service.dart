import '../../domain/resource/alert_sound_ref.dart';
import '../../infrastructure/audio/alert_sound_file_importer.dart';

class AlertSoundPickerService {
  final AlertSoundFileImporter importer;

  const AlertSoundPickerService({
    this.importer = const AlertSoundFileImporter(),
  });

  Future<AlertSoundRef?> pickCustomSound() => importer.pickAndImport();
}
