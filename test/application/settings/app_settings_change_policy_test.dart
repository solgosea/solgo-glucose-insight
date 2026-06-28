import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/settings/app_settings_change.dart';
import 'package:smart_xdrip/application/settings/app_settings_change_policy.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

void main() {
  group('AppSettingsChangePolicy', () {
    const policy = AppSettingsChangePolicy();

    test('treats glucose unit changes as display-only', () {
      final impact = policy.evaluate(
        const AppSettingsChange(
          previous: AppSettings(unit: GlucoseUnit.mmolL),
          next: AppSettings(unit: GlucoseUnit.mgDl),
        ),
      );

      expect(impact.persist, isTrue);
      expect(impact.refreshAnalysis, isFalse);
      expect(impact.applyRepositorySettings, isFalse);
      expect(impact.syncBackgroundService, isFalse);
      expect(impact.updateRuntime, isFalse);
    });

    test('refreshes analysis when glucose thresholds change', () {
      final impact = policy.evaluate(
        const AppSettingsChange(
          previous: AppSettings(highThreshold: 10.0),
          next: AppSettings(highThreshold: 9.5),
        ),
      );

      expect(impact.persist, isTrue);
      expect(impact.refreshAnalysis, isTrue);
      expect(impact.applyRepositorySettings, isFalse);
      expect(impact.updateRuntime, isFalse);
    });

    test('updates source runtime when sync strategy changes', () {
      final impact = policy.evaluate(
        const AppSettingsChange(
          previous: AppSettings(),
          next: AppSettings(
            nightscoutBaseUrl: 'http://localhost:1337',
            nightscoutSyncEnabled: true,
          ),
        ),
      );

      expect(impact.persist, isTrue);
      expect(impact.applyRepositorySettings, isTrue);
      expect(impact.syncBackgroundService, isTrue);
      expect(impact.updateForegroundPolling, isTrue);
      expect(impact.updateRuntime, isTrue);
    });

    test('updates foreground polling when sync interval changes', () {
      final impact = policy.evaluate(
        const AppSettingsChange(
          previous: AppSettings(syncIntervalMinutes: 1),
          next: AppSettings(syncIntervalMinutes: 5),
        ),
      );

      expect(impact.persist, isTrue);
      expect(impact.applyRepositorySettings, isTrue);
      expect(impact.syncBackgroundService, isTrue);
      expect(impact.updateForegroundPolling, isTrue);
      expect(impact.updateRuntime, isFalse);
    });
  });
}
