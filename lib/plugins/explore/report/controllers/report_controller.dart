import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import 'package:smart_xdrip/presentation/common/date_filter/domain/date_filter_selection.dart';
import 'package:smart_xdrip/reporting/application/report_export_action.dart';

import '../../../../application/analysis/analysis_facade.dart';
import '../application/report_default_sections.dart';
import '../application/report_export_use_case.dart';
import '../application/report_service.dart';
import '../domain/report_date_filter.dart';
import '../l10n/generated/report_localizations.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';
import '../runtime/report_plugin_runtime.dart';
import '../runtime/report_runtime_cache.dart';

class ReportController extends ChangeNotifier {
  final Listenable changeSignal;
  final ReportService service;
  final ReportExportUseCase exportUseCase;
  final ReportRuntimeCache? runtimeCache;
  final ReportPluginRuntime? runtime;
  final PluginRuntimeContext? runtimeContext;

  ReportPeriod _selectedPeriod = ReportPeriod.days30;
  late ReportDateFilter _dateFilter;
  ReportViewModel? _viewModel;
  bool _loading = false;
  bool _exporting = false;
  bool _disposed = false;
  int _loadVersion = 0;
  List<ReportSectionToggle> _sections = defaultSections;
  ReportLocalizations? _l10n;

  ReportController({
    required this.changeSignal,
    this.service = const ReportService(),
    ReportExportUseCase? exportUseCase,
    this.runtimeCache,
    this.runtime,
    this.runtimeContext,
  }) : exportUseCase = exportUseCase ?? const ReportExportUseCase() {
    _dateFilter = ReportDateFilter.defaultValue(_dateAnchor());
    changeSignal.addListener(_handleHostChanged);
  }

  ReportViewModel? get viewModel => _viewModel;
  bool get loading => _loading;
  bool get exporting => _exporting;
  DateFilterSelection get dateSelection => _dateFilter.selection;
  Map<DateTime, int> get dayReadingCounts =>
      _dayReadingCounts(AnalysisFacade.current().readings);

  Future<void> updateLocale(ReportLocalizations l10n) async {
    if (_l10n?.localeName == l10n.localeName) return;
    _l10n = l10n;
    if (_viewModel != null) {
      await load();
    }
  }

  Future<void> load() async {
    final version = ++_loadVersion;
    _loading = true;
    _notify();
    final facade = AnalysisFacade.current();
    final next = await _preheatOrAnalyze(
      facade: facade,
      period: _selectedPeriod,
      dateFilter: _dateFilter,
      sections: _sections,
    );
    if (_disposed || version != _loadVersion) return;
    _viewModel = next;
    _loading = false;
    _notify();
  }

  Future<void> selectPeriod(ReportPeriod period) async {
    if (_disposed || period == _selectedPeriod) return;
    _selectedPeriod = period;
    _dateFilter = ReportDateFilter(
      selection: _selectionForPeriod(period, _dateAnchor()),
      period: period,
    );
    await load();
  }

  Future<void> selectDateRange(DateFilterSelection selection) async {
    if (_disposed) return;
    _dateFilter = _dateFilter.copyWithSelection(selection);
    _selectedPeriod = _dateFilter.period ?? _selectedPeriod;
    await load();
  }

  void toggleSection(ReportSectionKey key) {
    _sections = [
      for (final section in _sections)
        if (section.key == key)
          section.copyWith(enabled: !section.enabled)
        else
          section,
    ];
    final current = _viewModel;
    if (current != null) {
      _viewModel = current.copyWith(sections: _localizedSections(_sections));
      _notify();
    }
  }

  Future<void> export(ReportExportAction action) async {
    final current = _viewModel;
    if (current == null || _exporting || !current.hasData) return;
    _exporting = true;
    _notify();
    try {
      await exportUseCase.execute(
        current,
        action: action,
        dateFilter: _dateFilter,
      );
    } finally {
      if (!_disposed) {
        _exporting = false;
        _notify();
      }
    }
  }

  Future<void> _handleHostChanged() async {
    if (_disposed) return;
    await load();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<ReportViewModel> _preheatOrAnalyze({
    required AnalysisFacade facade,
    required ReportPeriod period,
    required ReportDateFilter dateFilter,
    required List<ReportSectionToggle> sections,
  }) async {
    final context = runtimeContext;
    if (context != null && _canUseRuntimeSnapshot(dateFilter)) {
      await runtime?.preheatPeriod(
        context,
        period: period,
        sections: sections,
        reason: 'controller',
      );
    }

    return service.buildFromFacade(
      facade: facade,
      period: period,
      sections: sections,
      start: dateFilter.selection.start,
      end: dateFilter.selection.end,
      l10n: _l10n,
    );
  }

  List<ReportSectionToggle> _localizedSections(
    List<ReportSectionToggle> sections,
  ) {
    final l10n = _l10n;
    if (l10n == null) return sections;
    return [
      for (final section in sections)
        ReportSectionToggle(
          key: section.key,
          title: _sectionTitle(section.key, l10n),
          subtitle: _sectionSubtitle(section.key, l10n),
          enabled: section.enabled,
        ),
    ];
  }

  String _sectionTitle(ReportSectionKey key, ReportLocalizations l10n) {
    switch (key) {
      case ReportSectionKey.keyMetrics:
        return l10n.toggleKeyMetricsTitle;
      case ReportSectionKey.agpChart:
        return l10n.toggleAgpChartTitle;
      case ReportSectionKey.dailyCurves:
        return l10n.toggleDailyCurvesTitle;
      case ReportSectionKey.periodAnalysis:
        return l10n.togglePeriodAnalysisTitle;
      case ReportSectionKey.episodesSummary:
        return l10n.toggleEpisodesSummaryTitle;
    }
  }

  String _sectionSubtitle(ReportSectionKey key, ReportLocalizations l10n) {
    switch (key) {
      case ReportSectionKey.keyMetrics:
        return l10n.toggleKeyMetricsSubtitle;
      case ReportSectionKey.agpChart:
        return l10n.toggleAgpChartSubtitle;
      case ReportSectionKey.dailyCurves:
        return l10n.toggleDailyCurvesSubtitle;
      case ReportSectionKey.periodAnalysis:
        return l10n.togglePeriodAnalysisSubtitle;
      case ReportSectionKey.episodesSummary:
        return l10n.toggleEpisodesSummarySubtitle;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _loadVersion++;
    changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }

  static final defaultSections = ReportDefaultSections.values;

  DateFilterSelection _selectionForPeriod(ReportPeriod period, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return DateFilterSelection(
      start: today.subtract(Duration(days: period.days - 1)),
      end: today,
    );
  }

  bool _canUseRuntimeSnapshot(ReportDateFilter filter) {
    if (!filter.isPresetWindow) return false;
    final anchor = _anchorDay();
    return filter.selection.end == anchor;
  }

  DateTime _dateAnchor() {
    final readings = AnalysisFacade.current().readings;
    if (readings.isEmpty) return DateTime.now();
    return readings.last.timestamp;
  }

  DateTime _anchorDay() {
    final anchor = _dateAnchor();
    return DateTime(anchor.year, anchor.month, anchor.day);
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
}
