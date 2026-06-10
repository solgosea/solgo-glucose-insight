import '../../../domain/entities/app_settings.dart';

class SettingsActions {
  final AppSettings Function() settingsProvider;
  final Future<void> Function(AppSettings next) updateSettings;

  const SettingsActions({
    required this.settingsProvider,
    required this.updateSettings,
  });
}
