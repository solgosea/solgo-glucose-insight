import 'package:flutter/foundation.dart';

import '../application/insights_host_services.dart';
import '../application/insights_service.dart';
import '../application/i18n/insights_l10n_resolver.dart';
import '../engine/insights_engine_output.dart';
import '../l10n/generated/insights_localizations.dart';
import '../mappers/insights_view_model_mapper.dart';
import '../models/insights_view_model.dart';
import '../runtime/insights_plugin_runtime.dart';
import '../runtime/insights_runtime_cache.dart';

class InsightsController extends ChangeNotifier {
  final InsightsHostServices hostServices;
  final InsightsRuntimeCache runtimeCache;
  final InsightsPluginRuntime runtime;
  final InsightsViewModelMapper mapper;

  InsightsViewModel? viewModel;
  InsightsEngineOutput? _output;
  InsightsLocalizations _l10n = InsightsL10nResolver.fallback;

  InsightsController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
    this.mapper = const InsightsViewModelMapper(),
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  void updateLocale(InsightsLocalizations l10n) {
    if (_l10n.localeName == l10n.localeName) return;
    _l10n = l10n;
    if (_output != null) {
      _remap(_output!);
    }
  }

  Future<void> init() => _load();

  Future<void> _load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshOutput(
      subjectId: facade.activeSubject.id,
    );
    if (cached != null) {
      _remap(cached);
      return;
    }

    final snapshot = await runtime.preheat();
    if (snapshot == null) return;
    _remap(snapshot.output);
  }

  void _remap(InsightsEngineOutput output) {
    _output = output;
    viewModel = mapper.map(output, l10n: _l10n);
    notifyListeners();
  }

  void _handleHostChanged() {
    runtimeCache.markStale('hostChanged');
    final output = InsightsService(hostServices: hostServices).load();
    _remap(output);
  }

  @override
  void dispose() {
    hostServices.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }
}
