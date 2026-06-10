import '../../../domain/entities/app_settings.dart';
import '../target_range/target_range_value_policy.dart';

class ProfileSettingsActions {
  final Future<void> Function(AppSettings settings) updateSettings;
  final AppSettings Function() settingsProvider;

  const ProfileSettingsActions({
    required this.updateSettings,
    required this.settingsProvider,
  });

  Future<void> updateTargetRange(TargetRangeDraft draft) {
    final current = settingsProvider();
    return updateSettings(
      current.copyWith(
        lowThreshold: draft.lowMmol,
        highThreshold: draft.highMmol,
        veryHighThreshold: draft.veryHighMmol,
      ),
    );
  }

  Future<void> updateUnit(GlucoseUnit unit) {
    final current = settingsProvider();
    return updateSettings(current.copyWith(unit: unit));
  }
}
