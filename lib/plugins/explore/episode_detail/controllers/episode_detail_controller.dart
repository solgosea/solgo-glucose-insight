import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';

import '../application/episode_detail_service.dart';
import '../domain/episode_detail_entry_intent.dart';
import '../engine/episode_detail_engine_output.dart';
import '../mappers/episode_detail_view_model_mapper.dart';
import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import '../runtime/episode_detail_plugin_runtime.dart';
import '../runtime/episode_detail_runtime_cache.dart';
import '../runtime/episode_detail_runtime_snapshot.dart';

class EpisodeDetailController extends ChangeNotifier {
  final EpisodeDetailEntryIntent intent;
  final EpisodeDetailRuntimeCache? runtimeCache;
  final EpisodeDetailPluginRuntime? runtime;
  final PluginRuntimeContext? runtimeContext;
  final EpisodeDetailService? service;
  EpisodeDetailViewModelMapper _mapper;

  EpisodeDetailEngineOutput? _output;
  EpisodeDetailViewModel? _viewModel;
  bool _disposed = false;
  int _loadVersion = 0;

  EpisodeDetailController({
    required this.intent,
    this.runtimeCache,
    this.runtime,
    this.runtimeContext,
    this.service,
    EpisodeDetailViewModelMapper mapper = const EpisodeDetailViewModelMapper(),
  }) : _mapper = mapper;

  EpisodeDetailViewModel? get viewModel => _viewModel;

  EpisodeKind get kind => intent.kind;

  Future<void> load() async {
    if (_disposed) return;
    final version = ++_loadVersion;
    final facade = AnalysisFacade.current();
    final cached = runtimeCache?.freshSnapshot(
      subjectId: facade.activeSubject.id,
      kind: kind,
      focus: intent.focus,
    );
    final nextOutput = cached?.output ?? await _preheatOrLoad(facade: facade);
    if (_disposed || version != _loadVersion) return;
    _output = nextOutput;
    _viewModel = _mapper.map(nextOutput);
    notifyListeners();
  }

  void remapWith(EpisodeDetailViewModelMapper mapper) {
    _mapper = mapper;
    final output = _output;
    if (_disposed || output == null) return;
    _viewModel = _mapper.map(output);
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _loadVersion++;
    super.dispose();
  }

  Future<EpisodeDetailEngineOutput> _preheatOrLoad({
    required AnalysisFacade facade,
  }) async {
    final context = runtimeContext;
    final snapshot = intent.isFocused || context == null
        ? null
        : await runtime?.preheatKind(
            context,
            kind: kind,
            reason: 'controller',
          );
    if (snapshot != null) return snapshot.output;
    final effectiveService = service ??
        EpisodeDetailService(
          facadeProvider: AnalysisFacade.current,
        );
    final output = effectiveService.load(intent: intent);
    runtimeCache?.put(
      EpisodeDetailRuntimeSnapshot(
        subjectId: output.query.subjectId,
        kind: kind,
        focus: intent.focus,
        output: output,
        updatedAt: DateTime.now(),
        reason: intent.isFocused ? 'focused' : 'controller',
      ),
    );
    return output;
  }
}
