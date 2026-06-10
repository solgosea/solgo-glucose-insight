import 'package:flutter/foundation.dart';

import '../application/statistics_host_services.dart';
import '../models/statistics_view_model.dart';
import '../runtime/statistics_plugin_runtime.dart';
import '../runtime/statistics_runtime_cache.dart';

class StatisticsController extends ChangeNotifier {
  final StatisticsHostServices hostServices;
  final StatisticsRuntimeCache runtimeCache;
  final StatisticsPluginRuntime runtime;

  int _selectedPeriod = 14;
  StatisticsViewModel? viewModel;

  StatisticsController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  Future<void> init() => _load();

  void selectPeriod(int days) {
    if (_selectedPeriod == days) return;
    _selectedPeriod = days;
    _load();
  }

  Future<void> _load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshViewModel(
      subjectId: facade.activeSubject.id,
      periodDays: _selectedPeriod,
    );
    if (cached != null) {
      viewModel = cached;
      notifyListeners();
      return;
    }

    final snapshot = await runtime.preheatPeriod(periodDays: _selectedPeriod);
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
