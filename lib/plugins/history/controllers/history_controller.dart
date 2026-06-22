import 'package:flutter/foundation.dart';

import '../../../application/analysis/analysis_facade.dart';
import '../application/history_service.dart';
import '../application/history_host_services.dart';
import '../application/i18n/history_l10n_resolver.dart';
import '../domain/history_time_filter.dart';
import '../l10n/generated/history_localizations.dart';
import '../models/history_view_model.dart';
import '../runtime/history_plugin_runtime.dart';
import '../runtime/history_runtime_cache.dart';

class HistoryController extends ChangeNotifier {
  final HistoryHostServices hostServices;
  final HistoryRuntimeCache runtimeCache;
  final HistoryPluginRuntime runtime;
  final HistoryService service;

  DateTime _selectedDay = DateTime.now();
  HistoryTimeFilter? _timeFilter;
  HistoryLocalizations _l10n = HistoryL10nResolver.fallback;
  HistoryViewModel? viewModel;

  HistoryController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
    this.service = const HistoryService(),
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  DateTime get selectedDay => _selectedDay;
  HistoryTimeFilter? get timeFilter => _timeFilter;

  Future<void> init() => _load();

  void updateLocale(HistoryLocalizations l10n) {
    if (_l10n.localeName == l10n.localeName) return;
    _l10n = l10n;
    if (viewModel != null) {
      viewModel = _deriveViewModel(hostServices.facadeProvider(), _timeFilter);
      notifyListeners();
    }
  }

  void prevDay() {
    _selectedDay = _selectedDay.subtract(const Duration(days: 1));
    _timeFilter = null;
    _load();
  }

  void nextDay() {
    if (isToday) return;
    _selectedDay = _selectedDay.add(const Duration(days: 1));
    _timeFilter = null;
    _load();
  }

  void selectTimeFilter(DateTime time) {
    _timeFilter = HistoryTimeFilter(time: time);
    _load();
  }

  void clearTimeFilter() {
    if (_timeFilter == null) return;
    _timeFilter = null;
    _load();
  }

  bool get isToday {
    final today = DateTime.now();
    return _selectedDay.year == today.year &&
        _selectedDay.month == today.month &&
        _selectedDay.day == today.day;
  }

  Future<void> _load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshViewModel(
      subjectId: facade.activeSubject.id,
      day: _selectedDay,
    );
    if (cached != null) {
      viewModel = _deriveViewModel(facade, _timeFilter);
      notifyListeners();
      return;
    }

    final snapshot = await runtime.preheatDay(day: _selectedDay);
    if (snapshot == null) return;
    viewModel = _deriveViewModel(facade, _timeFilter);
    notifyListeners();
  }

  HistoryViewModel _deriveViewModel(
    AnalysisFacade facade,
    HistoryTimeFilter? filter,
  ) {
    final selectedDay = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    final readings = facade.readingsForDay(selectedDay);
    final tir = readings.isNotEmpty ? facade.tirForReadings(readings) : null;
    final facadeEvents = facade.eventsForDay(selectedDay);
    final events = facadeEvents.isNotEmpty
        ? facadeEvents
        : facade.detectEventsForReadings(readings);
    return service.buildViewModel(
      selectedDay: selectedDay,
      readings: readings,
      events: events,
      tir: tir,
      isToday: isToday,
      settings: hostServices.settingsProvider(),
      timeFilter: filter,
      l10n: _l10n,
    );
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
