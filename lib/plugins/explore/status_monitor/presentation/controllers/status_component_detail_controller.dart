import 'package:flutter/foundation.dart';

import '../../domain/status_component_kind.dart';
import '../../runtime/status_monitor_runtime_cache.dart';
import '../mappers/status_view_model_mapper.dart';
import '../models/status_view_models.dart';

class StatusComponentDetailController extends ChangeNotifier {
  final StatusMonitorRuntimeCache cache;
  final StatusComponentKind kind;
  final StatusViewModelMapper mapper;

  StatusComponentDetailViewModel? _viewModel;

  StatusComponentDetailController({
    required this.cache,
    required this.kind,
    this.mapper = const StatusViewModelMapper(),
  }) {
    cache.addListener(_refresh);
    _refresh();
  }

  bool get loading => cache.loading && cache.report == null;
  Object? get error => cache.error;
  StatusComponentDetailViewModel? get viewModel => _viewModel;

  void _refresh() {
    final report = cache.report;
    if (report != null) {
      _viewModel = mapper.detail(report, kind);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    cache.removeListener(_refresh);
    super.dispose();
  }
}
