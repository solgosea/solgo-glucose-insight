import 'package:flutter/foundation.dart';

import '../application/statistics_host_services.dart';
import '../application/statistics_service.dart';
import '../application/statistics_window_policy.dart';
import '../application/i18n/statistics_l10n_resolver.dart';
import '../domain/statistics_date_filter.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../engine/statistics_engine_output.dart';
import '../l10n/generated/statistics_localizations.dart';
import '../mappers/statistics_view_model_mapper.dart';
import '../models/statistics_view_model.dart';
import '../runtime/statistics_plugin_runtime.dart';
import '../runtime/statistics_runtime_cache.dart';

class StatisticsController extends ChangeNotifier {
  final StatisticsHostServices hostServices;
  final StatisticsRuntimeCache runtimeCache;
  final StatisticsPluginRuntime runtime;
  final StatisticsWindowPolicy windowPolicy;
  final StatisticsViewModelMapper mapper;

  late StatisticsAnalysisWindowId _selectedWindowId =
      windowPolicy.defaultWindowId;
  late StatisticsDateFilter _dateFilter =
      StatisticsDateFilter.defaultValue(DateTime.now());
  String? _customRangeLabel;
  StatisticsLocalizations _l10n = StatisticsL10nResolver.fallback;
  StatisticsEngineOutput? _lastOutput;
  StatisticsViewModel? viewModel;

  StatisticsController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
    this.windowPolicy = const StatisticsWindowPolicy(),
    this.mapper = const StatisticsViewModelMapper(),
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  Future<void> init() => _load();

  DateFilterSelection get dateSelection => _dateFilter.selection;

  Map<DateTime, int> get dayReadingCounts =>
      _dayReadingCounts(hostServices.facadeProvider().readings);

  void updateLocale(StatisticsLocalizations l10n) {
    if (_l10n.localeName == l10n.localeName) return;
    _l10n = l10n;
    final output = _lastOutput;
    if (output != null) {
      viewModel = mapper.map(output, l10n: _l10n);
      notifyListeners();
    }
  }

  void selectWindow(StatisticsAnalysisWindowId id) {
    if (_selectedWindowId == id) return;
    _selectedWindowId = id;
    _dateFilter =
        StatisticsDateFilter.defaultValue(DateTime.now()).copyWithSelection(
      _selectionForWindow(id, DateTime.now()),
    );
    _customRangeLabel = null;
    _load();
  }

  void selectDateRange(DateFilterSelection selection, {String? rangeLabel}) {
    _dateFilter = _dateFilter.copyWithSelection(selection);
    _selectedWindowId = _dateFilter.windowId;
    _customRangeLabel = _dateFilter.isPresetWindow ? null : rangeLabel;
    _load();
  }

  Future<void> _load() async {
    final service = StatisticsService(hostServices: hostServices);
    final output = service.load(
      windowId: _selectedWindowId,
      dateFilter: _dateFilter,
      rangeLabel: _customRangeLabel,
    );
    _lastOutput = output;
    viewModel = mapper.map(output, l10n: _l10n);
    notifyListeners();
  }

  DateFilterSelection _selectionForWindow(
    StatisticsAnalysisWindowId id,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final days = switch (id) {
      StatisticsAnalysisWindowId.last24Hours => 1,
      StatisticsAnalysisWindowId.last3Days => 3,
      StatisticsAnalysisWindowId.last7Days => 7,
      StatisticsAnalysisWindowId.last14Days => 14,
      StatisticsAnalysisWindowId.last30Days => 30,
      StatisticsAnalysisWindowId.last90Days => 90,
    };
    return DateFilterSelection(
      start: today.subtract(Duration(days: days - 1)),
      end: today,
    );
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
