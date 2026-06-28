import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugins/settings/application/settings_host_services.dart';
import 'package:smart_xdrip/plugins/settings/application/settings_snapshot_preheater.dart';
import 'package:smart_xdrip/plugins/settings/mappers/settings_view_model_mapper.dart';
import 'package:smart_xdrip/plugins/settings/models/settings_analysis_result.dart';
import 'package:smart_xdrip/plugins/settings/runtime/settings_plugin_runtime.dart';
import 'package:smart_xdrip/plugins/settings/runtime/settings_runtime_cache.dart';

void main() {
  test('settings runtime preheats global settings snapshot', () async {
    final now = DateTime(2026, 6, 6, 12);
    final cache = SettingsRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      SettingsPluginRuntime(
        cache: cache,
        preheater: SettingsSnapshotPreheater(
          hostServices: _hostServices(now),
          now: () => now,
        ),
      ),
    );

    await manager.resume(SettingsPluginRuntime.id);

    expect(cache.stale, isFalse);
    expect(cache.snapshot, isNotNull);
    expect(cache.snapshot?.analysis.readingCount, 24);
    expect(cache.snapshot?.viewModel.storage.coveredLabel, '1 days');
  });

  test('settings runtime marks stale after settings changes', () async {
    final now = DateTime(2026, 6, 6, 12);
    final cache = SettingsRuntimeCache();
    final manager = PluginRuntimeManager.create(now: () => now);
    addTearDown(manager.dispose);
    manager.register(
      SettingsPluginRuntime(
        cache: cache,
        preheater: SettingsSnapshotPreheater(
          hostServices: _hostServices(now),
          now: () => now,
        ),
      ),
    );
    await manager.resume(SettingsPluginRuntime.id);
    expect(cache.stale, isFalse);

    manager.eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.settingsChanged,
        occurredAt: now.add(const Duration(minutes: 1)),
      ),
    );
    await pumpEventQueue();

    expect(cache.stale, isTrue);
    expect(cache.staleReason, PluginRuntimeEventType.settingsChanged.name);
  });

  test('settings mapper shows sync window and interval together', () {
    final now = DateTime(2026, 6, 6, 12);
    final vm = SettingsViewModelMapper().map(
      analysis: SettingsAnalysisResult(
        settings: const AppSettings(
          initialSyncDays: 30,
          syncIntervalMinutes: 5,
        ),
        dbBytes: 4096,
        readingCount: 24,
        earliestReading: now.subtract(const Duration(hours: 2)),
        latestReading: now,
        daysCovered: 1,
      ),
      saving: false,
    );

    final row = vm.sync.rows.single;
    expect(row.label, 'Sync window');
    expect(row.valueLabel, '30 days · every 5 min');
  });
}

SettingsHostServices _hostServices(DateTime now) {
  return SettingsHostServices(
    changeSignal: _NoopListenable(),
    settingsProvider: () => const AppSettings(retentionDays: 90),
    databaseFileSizeBytes: () async => 4096,
    readingsForDays: (days) async => List.generate(
      24,
      (index) => GlucoseReading(
        timestamp: now.subtract(Duration(minutes: (23 - index) * 5)),
        value: 5.8 + (index % 4) * 0.2,
        ratePerMin: 0.01,
      ),
    ),
  );
}

class _NoopListenable extends Listenable {
  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}
