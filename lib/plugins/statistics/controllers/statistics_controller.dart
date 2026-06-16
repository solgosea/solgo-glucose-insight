import 'package:flutter/foundation.dart';

import '../application/statistics_host_services.dart';
import '../application/statistics_window_policy.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../models/statistics_view_model.dart';
import '../runtime/statistics_plugin_runtime.dart';
import '../runtime/statistics_runtime_cache.dart';

class StatisticsController extends ChangeNotifier {
  final StatisticsHostServices hostServices;
  final StatisticsRuntimeCache runtimeCache;
  final StatisticsPluginRuntime runtime;
  final StatisticsWindowPolicy windowPolicy;

  late StatisticsAnalysisWindowId _selectedWindowId =
      windowPolicy.defaultWindowId;
  StatisticsViewModel? viewModel;

  StatisticsController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
    this.windowPolicy = const StatisticsWindowPolicy(),
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  Future<void> init() => _load();

  void selectWindow(StatisticsAnalysisWindowId id) {
    if (_selectedWindowId == id) return;
    _selectedWindowId = id;
    _load();
  }

  Future<void> _load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshViewModel(
      subjectId: facade.activeSubject.id,
      windowId: _selectedWindowId,
    );
    if (cached != null) {
      viewModel = cached;
      notifyListeners();
      return;
    }

    final snapshot = await runtime.preheatWindow(windowId: _selectedWindowId);
    if (snapshot == null) return;
    viewModel = snapshot.viewModel;
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
