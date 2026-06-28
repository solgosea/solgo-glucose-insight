import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../application/history/status_history_service.dart';
import '../../application/history/status_history_parallel_loader.dart';
import '../../domain/history/status_component_history_load_result.dart';
import '../../domain/history/status_component_history_load_state.dart';
import '../../domain/status_component_kind.dart';
import '../history/mappers/status_history_view_model_mapper.dart';
import '../history/models/status_history_view_model.dart';
import '../../runtime/status_monitor_runtime_cache.dart';

class StatusHistoryController extends ChangeNotifier {
  final StatusMonitorRuntimeCache cache;
  final StatusHistoryService historyService;
  final StatusHistoryViewModelMapper mapper;
  final DateTime Function() now;
  late final StatusHistoryParallelLoader _parallelLoader;
  final Map<StatusComponentKind, StatusComponentHistoryLoadResult> _loads = {};
  String? _loadingKey;
  bool _loadingComponents = false;
  bool _disposed = false;

  StatusHistoryController({
    required this.cache,
    required this.historyService,
    this.mapper = const StatusHistoryViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now {
    _parallelLoader = StatusHistoryParallelLoader(
      historyService: historyService,
    );
    cache.addListener(_onCacheChanged);
    unawaited(_loadScopedHistory());
  }

  bool get loading =>
      (cache.loading && cache.report == null) ||
      (cache.report != null && _loadingComponents);
  Object? get error => cache.error;
  StatusHistoryViewModel get viewModel => mapper.mapProgressive(
        report: cache.report,
        loads: _loads,
        now: now(),
        loading: loading,
      );

  void _onCacheChanged() {
    notifyListeners();
    unawaited(_loadScopedHistory());
  }

  Future<void> _loadScopedHistory() async {
    final report = cache.report;
    if (report == null) {
      _loads.clear();
      notifyListeners();
      return;
    }
    final key = '${report.subjectId}|${report.sourceTargetId}|'
        '${report.sourceKind}|${report.generatedAt.millisecondsSinceEpoch}';
    if (_loadingKey == key) return;
    _loadingKey = key;
    final startedAt = now();
    _loadingComponents = true;
    _loads
      ..clear()
      ..addEntries(
        report.components.map(
          (component) => MapEntry(
            component.kind,
            StatusComponentHistoryLoadResult(
              component: component,
              state: StatusComponentHistoryLoadState.loading,
            ),
          ),
        ),
      );
    notifyListeners();

    await for (final load in _parallelLoader.load(
      report: report,
      components: report.components,
      now: startedAt,
    )) {
      if (_disposed || _loadingKey != key) return;
      _loads[load.component.kind] = load;
      notifyListeners();
    }
    if (_disposed || _loadingKey != key) return;
    _loadingComponents = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    cache.removeListener(_onCacheChanged);
    super.dispose();
  }
}
