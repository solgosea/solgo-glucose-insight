import 'package:flutter/foundation.dart';

import '../../../application/analysis/analysis_facade.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../../../presentation/common/date_filter/domain/date_filter_selection.dart';
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

  DateFilterSelection _dateSelection =
      DateFilterSelection.single(DateTime.now());
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

  DateTime get selectedDay => _dateSelection.start;
  DateFilterSelection get dateSelection => _dateSelection;
  HistoryTimeFilter? get timeFilter => _timeFilter;
  Map<DateTime, int> get dayReadingCounts =>
      _dayReadingCounts(hostServices.facadeProvider().readings);

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
    _dateSelection = DateFilterSelection.single(
      _dateSelection.start.subtract(const Duration(days: 1)),
    );
    _timeFilter = null;
    _load();
  }

  void nextDay() {
    if (isToday) return;
    _dateSelection = DateFilterSelection.single(
      _dateSelection.start.add(const Duration(days: 1)),
    );
    _timeFilter = null;
    _load();
  }

  void selectDateRange(DateFilterSelection selection) {
    _dateSelection = DateFilterSelection.single(selection.start);
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
    return _dateSelection.isSingleDay &&
        _dateSelection.start.year == today.year &&
        _dateSelection.start.month == today.month &&
        _dateSelection.start.day == today.day;
  }

  Future<void> _load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshViewModel(
      subjectId: facade.activeSubject.id,
      day: _dateSelection.start,
    );
    if (cached != null) {
      viewModel = _deriveViewModel(facade, _timeFilter);
      notifyListeners();
      return;
    }

    final snapshot = await runtime.preheatDay(day: _dateSelection.start);
    if (snapshot == null) return;
    viewModel = _deriveViewModel(facade, _timeFilter);
    notifyListeners();
  }

  HistoryViewModel _deriveViewModel(
    AnalysisFacade facade,
    HistoryTimeFilter? filter,
  ) {
    final selectedDay = _dateSelection.start;
    final readings = _readingsInSelection(facade.readings, _dateSelection);
    final tir = readings.isNotEmpty ? facade.tirForReadings(readings) : null;
    final facadeEvents = _eventsInSelection(
      facade.snapshot?.events ?? const <GlucoseEvent>[],
      _dateSelection,
    );
    final events = facadeEvents.isNotEmpty
        ? facadeEvents
        : facade.detectEventsForReadings(readings);
    return service.buildViewModel(
      selectedDay: selectedDay,
      rangeStart: _dateSelection.start,
      rangeEnd: _dateSelection.end,
      readings: readings,
      events: events,
      tir: tir,
      isToday: isToday,
      settings: hostServices.settingsProvider(),
      timeFilter: filter,
      l10n: _l10n,
    );
  }

  List<GlucoseReading> _readingsInSelection(
    List<GlucoseReading> readings,
    DateFilterSelection selection,
  ) {
    return readings
        .where((reading) =>
            !reading.timestamp.isBefore(selection.start) &&
            reading.timestamp.isBefore(selection.exclusiveEnd))
        .toList();
  }

  List<GlucoseEvent> _eventsInSelection(
    List<GlucoseEvent> events,
    DateFilterSelection selection,
  ) {
    return events
        .where((event) =>
            !event.time.isBefore(selection.start) &&
            event.time.isBefore(selection.exclusiveEnd))
        .toList();
  }

  Map<DateTime, int> _dayReadingCounts(List<GlucoseReading> readings) {
    final output = <DateTime, int>{};
    for (final reading in readings) {
      final day = DateTime(
        reading.timestamp.year,
        reading.timestamp.month,
        reading.timestamp.day,
      );
      output[day] = (output[day] ?? 0) + 1;
    }
    return output;
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
