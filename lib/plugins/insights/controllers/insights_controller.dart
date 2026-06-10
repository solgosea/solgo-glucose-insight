import 'package:flutter/foundation.dart';

import '../application/insights_host_services.dart';
import '../models/insights_view_model.dart';
import '../runtime/insights_plugin_runtime.dart';
import '../runtime/insights_runtime_cache.dart';

class InsightsController extends ChangeNotifier {
  final InsightsHostServices hostServices;
  final InsightsRuntimeCache runtimeCache;
  final InsightsPluginRuntime runtime;

  InsightsViewModel? viewModel;

  InsightsController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  Future<void> init() => _load();

  Future<void> _load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshViewModel(
      subjectId: facade.activeSubject.id,
    );
    if (cached != null) {
      viewModel = cached;
      notifyListeners();
      return;
    }

    final snapshot = await runtime.preheat();
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
