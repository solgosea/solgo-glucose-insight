import 'package:flutter/foundation.dart';

import '../mappers/status_dashboard_state_mapper.dart';
import '../../runtime/status_monitor_runtime_cache.dart';
import '../../l10n/generated/status_monitor_localizations.dart';
import '../mappers/status_view_model_mapper.dart';
import '../models/status_dashboard_state.dart';
import '../models/status_view_models.dart';

class StatusDashboardController extends ChangeNotifier {
  final StatusMonitorRuntimeCache cache;
  final StatusViewModelMapper mapper;
  final StatusDashboardStateMapper stateMapper;

  StatusDashboardViewModel? _viewModel;
  late StatusDashboardState _dashboardState;
  StatusMonitorLocalizations? _l10n;
  bool _disposed = false;

  StatusDashboardController({
    required this.cache,
    this.mapper = const StatusViewModelMapper(),
    this.stateMapper = const StatusDashboardStateMapper(),
  }) {
    _dashboardState = stateMapper.map(
      viewModel: null,
      sessionState: null,
      error: null,
      loading: true,
    );
    cache.addListener(_refresh);
    _refresh();
  }

  bool get loading => cache.loading && cache.report == null;
  Object? get error => cache.error;
  StatusDashboardViewModel? get viewModel => _viewModel;
  StatusDashboardState get dashboardState => _dashboardState;

  void setLocalizations(StatusMonitorLocalizations l10n) {
    if (identical(_l10n, l10n)) return;
    _l10n = l10n;
    _refresh();
  }

  Future<void> _refresh() async {
    final report = cache.report;
    if (report == null) {
      final nextState = stateMapper.map(
        viewModel: _viewModel,
        sessionState: cache.sessionState,
        error: cache.error,
        loading: cache.loading,
      );
      _emitIfChanged(nextState);
      return;
    }
    _viewModel = mapper.dashboard(report, l10n: _l10n);
    final nextState = stateMapper.map(
      viewModel: _viewModel,
      sessionState: cache.sessionState,
      error: cache.error,
      loading: cache.loading,
    );
    _emitIfChanged(nextState);
  }

  void _emitIfChanged(StatusDashboardState nextState) {
    final current = _dashboardState;
    final changed =
        !identical(current.viewModel.report, nextState.viewModel.report) ||
            _componentSignature(current.viewModel) !=
                _componentSignature(nextState.viewModel) ||
            current.notice?.title != nextState.notice?.title ||
            current.notice?.body != nextState.notice?.body ||
            current.setupPrompt?.title != nextState.setupPrompt?.title ||
            current.setupPrompt?.body != nextState.setupPrompt?.body ||
            current.refreshing != nextState.refreshing;
    _dashboardState = nextState;
    if (changed && !_disposed) notifyListeners();
  }

  String _componentSignature(StatusDashboardViewModel viewModel) {
    return viewModel.components
        .map(
          (component) => [
            component.component.kind.name,
            component.component.level.name,
            component.component.score?.value,
            component.freshnessText,
            component.checkPhase?.name,
            component.checkStepLabel,
          ].join(':'),
        )
        .join('|');
  }

  @override
  void dispose() {
    _disposed = true;
    cache.removeListener(_refresh);
    super.dispose();
  }
}
