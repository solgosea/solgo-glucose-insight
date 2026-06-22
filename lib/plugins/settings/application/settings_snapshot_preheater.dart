import 'package:smart_xdrip/core/app_metadata.dart';

import '../analyzers/settings_storage_analyzer.dart';
import '../mappers/settings_view_model_mapper.dart';
import '../runtime/settings_runtime_cache.dart';
import 'settings_host_services.dart';

class SettingsSnapshotPreheater {
  final SettingsHostServices hostServices;
  final SettingsStorageAnalyzer storageAnalyzer;
  final SettingsViewModelMapper mapper;
  final DateTime Function() now;

  SettingsSnapshotPreheater({
    required this.hostServices,
    this.storageAnalyzer = const SettingsStorageAnalyzer(),
    SettingsViewModelMapper? mapper,
    DateTime Function()? now,
  })  : mapper = mapper ?? SettingsViewModelMapper(),
        now = now ?? DateTime.now;

  Future<SettingsRuntimeSnapshot> preheat() async {
    final settings = hostServices.settingsProvider();
    final appMetadata = await AppMetadata.fromPlatform();
    final analysis = await storageAnalyzer.analyze(
      settings: settings,
      databaseFileSizeBytes: hostServices.databaseFileSizeBytes,
      readingsForDays: hostServices.readingsForDays,
    );
    return SettingsRuntimeSnapshot(
      viewModel: mapper.map(
        analysis: analysis,
        saving: false,
        appMetadata: appMetadata,
      ),
      analysis: analysis,
      updatedAt: now(),
    );
  }
}
