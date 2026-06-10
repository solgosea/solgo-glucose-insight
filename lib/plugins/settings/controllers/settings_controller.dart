import 'package:flutter/foundation.dart';

import 'package:smart_xdrip/domain/entities/app_settings.dart';
import '../application/settings_actions.dart';
import '../application/settings_export_actions.dart';
import '../application/settings_host_services.dart';
import '../application/settings_storage_actions.dart';
import '../mappers/settings_view_model_mapper.dart';
import '../models/settings_analysis_result.dart';
import '../models/settings_view_model.dart';
import '../runtime/settings_plugin_runtime.dart';
import '../runtime/settings_runtime_cache.dart';

class SettingsController extends ChangeNotifier {
  final SettingsHostServices hostServices;
  final SettingsActions settingsActions;
  final SettingsStorageActions storageActions;
  final SettingsExportActions exportActions;
  final SettingsRuntimeCache runtimeCache;
  final SettingsPluginRuntime runtime;
  final SettingsViewModelMapper mapper;

  SettingsController({
    required this.hostServices,
    required this.settingsActions,
    required this.storageActions,
    required this.exportActions,
    required this.runtimeCache,
    required this.runtime,
    this.mapper = const SettingsViewModelMapper(),
  }) : _settings = settingsActions.settingsProvider();

  AppSettings _settings;
  SettingsAnalysisResult? _analysis;
  SettingsViewModel? _viewModel;
  bool _saving = false;

  AppSettings get settings => _settings;
  bool get saving => _saving;
  SettingsViewModel? get viewModel => _viewModel;

  String get unitLabel {
    return switch (_settings.unit) {
      GlucoseUnit.mmolL => 'mmol/L',
      GlucoseUnit.mgDl => 'mg/dL',
    };
  }

  Future<void> load() async {
    _settings = settingsActions.settingsProvider();
    final snapshot = runtimeCache.snapshot ?? await runtime.preheat();
    _analysis = snapshot.analysis;
    _viewModel = snapshot.viewModel;
    _refreshViewModel();
  }

  Future<void> refreshStorageStats() => load();

  Future<void> setUnitLabel(String value) async {
    final unit = value == 'mg/dL' ? GlucoseUnit.mgDl : GlucoseUnit.mmolL;
    await _save(_settings.copyWith(unit: unit));
  }

  Future<void> setInitialSyncDays(int days) async {
    final normalized = switch (days) {
      7 || 14 || 30 => days,
      _ => 14,
    };
    await _save(_settings.copyWith(initialSyncDays: normalized));
  }

  Future<void> setDataHealthCheckEnabled(bool enabled) async {
    await _save(_settings.copyWith(dataHealthCheckEnabled: enabled));
  }

  Future<void> setDailyBriefEnabled(bool enabled) async {
    await _save(_settings.copyWith(dailyBriefEnabled: enabled));
  }

  Future<void> setWeeklyReviewEnabled(bool enabled) async {
    await _save(_settings.copyWith(weeklyReviewEnabled: enabled));
  }

  Future<void> clearAllData() async {
    await storageActions.clearAllData();
    runtimeCache.markStale('clearAllData');
    await load();
  }

  Future<String?> exportReadingsCsv() async {
    return exportActions.exportReadingsCsv(_settings);
  }

  Future<void> _save(AppSettings next) async {
    if (_saving || next == _settings) return;
    _saving = true;
    _settings = next;
    _analysis = _analysisWithSettings(next);
    _refreshViewModel();

    await settingsActions.updateSettings(next);
    _saving = false;
    runtimeCache.markStale('settingsSaved');
    await load();
  }

  SettingsAnalysisResult? _analysisWithSettings(AppSettings settings) {
    final current = _analysis;
    if (current == null) return null;
    return SettingsAnalysisResult(
      settings: settings,
      dbBytes: current.dbBytes,
      readingCount: current.readingCount,
      earliestReading: current.earliestReading,
      latestReading: current.latestReading,
      daysCovered: current.daysCovered,
    );
  }

  void _refreshViewModel() {
    final analysis = _analysis;
    if (analysis == null) {
      notifyListeners();
      return;
    }
    _viewModel = mapper.map(analysis: analysis, saving: _saving);
    notifyListeners();
  }
}
