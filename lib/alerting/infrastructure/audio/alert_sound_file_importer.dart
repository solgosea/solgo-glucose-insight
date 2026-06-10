import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/resource/alert_sound_ref.dart';

class AlertSoundFileImporter {
  const AlertSoundFileImporter();

  static const int maxImportedSoundBytes = 30 * 1024 * 1024;

  Future<AlertSoundRef?> pickAndImport() async {
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
      withData: false,
    );
    final picked = result?.files.single;
    final sourcePath = picked?.path;
    if (picked == null) {
      return null;
    }
    if (sourcePath == null || sourcePath.isEmpty) {
      return null;
    }

    final source = File(sourcePath);
    if (!await source.exists()) {
      return null;
    }
    if (await source.length() > maxImportedSoundBytes) {
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();
    final soundDirectory = Directory(p.join(directory.path, 'alert_sounds'));
    await soundDirectory.create(recursive: true);

    final extension =
        p.extension(picked.name).isNotEmpty
            ? p.extension(picked.name)
            : p.extension(sourcePath).isNotEmpty
            ? p.extension(sourcePath)
            : '.audio';
    final name =
        picked.name.trim().isNotEmpty
            ? p.basenameWithoutExtension(picked.name)
            : 'Custom alert';
    final safeName = name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]+'), '_');
    final importedPath = p.join(
      soundDirectory.path,
      '${DateTime.now().millisecondsSinceEpoch}_$safeName$extension',
    );
    await source.copy(importedPath);

    return AlertSoundRef.file(uri: importedPath, displayName: name);
  }
}
