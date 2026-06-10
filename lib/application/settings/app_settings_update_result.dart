import 'app_settings_change_policy.dart';

class AppSettingsUpdateResult {
  final AppSettingsChangeImpact impact;
  final bool applied;

  const AppSettingsUpdateResult({required this.impact, required this.applied});
}
