import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';

import '../mappers/episode_detail_view_model_mapper.dart';
import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import '../runtime/episode_detail_plugin_runtime.dart';
import '../runtime/episode_detail_runtime_cache.dart';

class EpisodeDetailController extends ChangeNotifier {
  final EpisodeKind kind;
  final EpisodeDetailRuntimeCache? runtimeCache;
  final EpisodeDetailPluginRuntime? runtime;
  final PluginRuntimeContext? runtimeContext;
  final EpisodeDetailViewModelMapper mapper;

  EpisodeDetailViewModel? _viewModel;
  bool _disposed = false;
  int _loadVersion = 0;

  EpisodeDetailController({
    required this.kind,
    this.runtimeCache,
    this.runtime,
    this.runtimeContext,
    this.mapper = const EpisodeDetailViewModelMapper(),
  });

  EpisodeDetailViewModel? get viewModel => _viewModel;

  Future<void> load() async {
    if (_disposed) return;
    final version = ++_loadVersion;
    final facade = AnalysisFacade.current();
    final cached = runtimeCache?.freshSnapshot(
      subjectId: facade.activeSubject.id,
      kind: kind,
    );
    final next = cached?.viewModel ?? await _preheatOrMap(facade: facade);
    if (_disposed || version != _loadVersion) return;
    _viewModel = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _loadVersion++;
    super.dispose();
  }

  Future<EpisodeDetailViewModel> _preheatOrMap({
    required AnalysisFacade facade,
  }) async {
    final context = runtimeContext;
    final snapshot =
        context == null
            ? null
            : await runtime?.preheatKind(
              context,
              kind: kind,
              reason: 'controller',
            );
    if (snapshot != null) return snapshot.viewModel;
    return mapper.map(kind: kind, facade: facade);
  }
}
