import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../application/history/status_history_service.dart';
import '../../domain/history/status_history_result.dart';
import '../history/mappers/status_history_view_model_mapper.dart';
import '../history/models/status_history_view_model.dart';
import '../../runtime/status_monitor_runtime_cache.dart';

class StatusHistoryController extends ChangeNotifier {
  final StatusMonitorRuntimeCache cache;
  final StatusHistoryService historyService;
  final StatusHistoryViewModelMapper mapper;
  final DateTime Function() now;
  StatusHistoryResult? _historyResult;
  String? _loadingKey;

  StatusHistoryController({
    required this.cache,
    required this.historyService,
    this.mapper = const StatusHistoryViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now {
    cache.addListener(_onCacheChanged);
    unawaited(_loadScopedHistory());
  }

  bool get loading => cache.loading && cache.report == null;
  Object? get error => cache.error;
  StatusHistoryViewModel get viewModel => mapper.map(
        result: _historyResult,
        report: cache.report,
        now: now(),
      );

  void _onCacheChanged() {
    notifyListeners();
    unawaited(_loadScopedHistory());
  }

  Future<void> _loadScopedHistory() async {
    final report = cache.report;
    if (report == null) return;
    final key = '${report.subjectId}|${report.sourceTargetId}|'
        '${report.sourceKind}|${report.generatedAt.millisecondsSinceEpoch}';
    if (_loadingKey == key) return;
    _loadingKey = key;
    final result = await historyService.loadForReport(
      report: report,
      now: now(),
    );
    if (_loadingKey != key) return;
    _historyResult = result;
    notifyListeners();
  }

  @override
  void dispose() {
    cache.removeListener(_onCacheChanged);
    super.dispose();
  }
}
