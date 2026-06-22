import 'package:flutter/foundation.dart';

import '../application/statistics_host_services.dart';
import '../application/statistics_service.dart';
import '../application/statistics_window_policy.dart';
import '../application/i18n/statistics_l10n_resolver.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../engine/statistics_engine_output.dart';
import '../l10n/generated/statistics_localizations.dart';
import '../mappers/statistics_view_model_mapper.dart';
import '../models/statistics_view_model.dart';
import '../runtime/statistics_plugin_runtime.dart';
import '../runtime/statistics_runtime_cache.dart';

class StatisticsController extends ChangeNotifier {
  final StatisticsHostServices hostServices;
  final StatisticsRuntimeCache runtimeCache;
  final StatisticsPluginRuntime runtime;
  final StatisticsWindowPolicy windowPolicy;
  final StatisticsViewModelMapper mapper;

  late StatisticsAnalysisWindowId _selectedWindowId =
      windowPolicy.defaultWindowId;
  StatisticsLocalizations _l10n = StatisticsL10nResolver.fallback;
  StatisticsEngineOutput? _lastOutput;
  StatisticsViewModel? viewModel;

  StatisticsController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
    this.windowPolicy = const StatisticsWindowPolicy(),
    this.mapper = const StatisticsViewModelMapper(),
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  Future<void> init() => _load();

  void updateLocale(StatisticsLocalizations l10n) {
    if (_l10n.localeName == l10n.localeName) return;
    _l10n = l10n;
    final output = _lastOutput;
    if (output != null) {
      viewModel = mapper.map(output, l10n: _l10n);
      notifyListeners();
    }
  }

  void selectWindow(StatisticsAnalysisWindowId id) {
    if (_selectedWindowId == id) return;
    _selectedWindowId = id;
    _load();
  }

  Future<void> _load() async {
    final service = StatisticsService(hostServices: hostServices);
    final output = service.load(windowId: _selectedWindowId);
    _lastOutput = output;
    viewModel = mapper.map(output, l10n: _l10n);
    notifyListeners();
  }

  void _handleHostChanged() {
    runtimeCache.markStale('hostChanged');
    _load();
  }

  @override
  void dispose() {
    hostServices.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }
}
