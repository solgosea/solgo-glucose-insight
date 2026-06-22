import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model_mapper.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';
import '../application/home_host_services.dart';
import '../application/i18n/home_l10n_resolver.dart';
import '../l10n/generated/home_localizations.dart';
import '../mappers/home_view_model_mapper.dart';
import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';
import '../runtime/home_plugin_runtime.dart';
import '../runtime/home_runtime_cache.dart';

class HomeController extends ChangeNotifier {
  final HomeHostServices hostServices;
  final HomeRuntimeCache? runtimeCache;
  final HomePluginRuntime? runtime;
  final HomeViewModelMapper _mapper;
  final SyncStatusViewModelMapper _syncStatusMapper;
  HomeLocalizations _l10n = HomeL10nResolver.fallback;

  HomeChartRange _selectedRange = HomeChartRange.fourHours;
  HomeViewModel? viewModel;
  SyncStatusViewModel _syncStatus = SyncStatusViewModel(
    label: HomeL10nResolver.fallback.homeCheckingSync,
    semanticLabel: HomeL10nResolver.fallback.homeCheckingSync,
    color: AppColors.textDim,
    pulsing: false,
    display: false,
  );
  bool _refreshing = false;
  bool _refreshAgain = false;
  bool _disposed = false;

  HomeController({
    required this.hostServices,
    this.runtimeCache,
    this.runtime,
    HomeViewModelMapper? mapper,
    SyncStatusViewModelMapper? syncStatusMapper,
  })  : _mapper = mapper ?? const HomeViewModelMapper(),
        _syncStatusMapper =
            syncStatusMapper ?? const SyncStatusViewModelMapper() {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  Future<void> init() async {
    await _refresh();
  }

  void updateLocale(HomeLocalizations l10n) {
    if (_l10n.localeName == l10n.localeName) return;
    _l10n = l10n;
    if (viewModel != null) _remap();
  }

  Future<void> selectRange(HomeChartRange range) async {
    if (_selectedRange == range) return;
    _selectedRange = range;
    _remap();
  }

  Future<void> switchBackToSelf() async {
    await hostServices.switchToSelfSubject();
    await _refresh();
  }

  Future<void> updateUnit(GlucoseUnit unit) async {
    if (viewModel?.unit == unit) return;
    await hostServices.updateUnit(unit);
    if (_disposed) return;
    _remap();
    unawaited(_refresh());
  }

  Future<void> _refresh() async {
    if (_disposed) return;
    if (_refreshing) {
      _refreshAgain = true;
      return;
    }
    _refreshing = true;
    final facade = AnalysisFacade.current();
    final cached = runtimeCache?.freshViewModel(
      subjectId: facade.activeSubject.id,
      range: _selectedRange,
    );
    if (cached != null) {
      _syncStatus = cached.syncStatus;
      _remap(notify: false);
    } else {
      final snapshot = await runtime?.preheatRange(range: _selectedRange);
      if (snapshot != null) {
        _syncStatus = snapshot.viewModel.syncStatus;
        _remap(notify: false);
      } else {
        final syncStatus = await hostServices.syncStatusSnapshot();
        _syncStatus = _syncStatusMapper.map(
          syncStatus,
          runtimeStatus: hostServices.syncRuntimeStatus(),
        );
        _remap(notify: false);
      }
    }
    _refreshing = false;
    if (_disposed) return;
    notifyListeners();
    if (_refreshAgain) {
      _refreshAgain = false;
      await _refresh();
    }
  }

  void _remap({bool notify = true}) {
    viewModel = _mapper.map(
      facade: AnalysisFacade.current(),
      selectedRange: _selectedRange,
      syncStatus: _syncStatus,
      l10n: _l10n,
    );
    if (notify && !_disposed) notifyListeners();
  }

  void _handleHostChanged() {
    if (_disposed) return;
    _remap();
    unawaited(_refresh());
  }

  @override
  void dispose() {
    _disposed = true;
    hostServices.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }
}
