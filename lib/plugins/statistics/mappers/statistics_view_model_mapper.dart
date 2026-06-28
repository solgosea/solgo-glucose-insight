import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../application/i18n/statistics_l10n_resolver.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../engine/statistics_engine_output.dart';
import '../l10n/generated/statistics_localizations.dart';
import '../models/statistics_view_model.dart';
import 'statistics_agp_view_model_mapper.dart';
import 'statistics_heatmap_view_model_mapper.dart';
import 'statistics_metrics_view_model_mapper.dart';
import 'statistics_tir_view_model_mapper.dart';

class StatisticsViewModelMapper {
  final StatisticsMetricsViewModelMapper metricsMapper;
  final StatisticsTirViewModelMapper tirMapper;
  final StatisticsAgpViewModelMapper agpMapper;
  final StatisticsHeatmapViewModelMapper heatmapMapper;

  const StatisticsViewModelMapper({
    this.metricsMapper = const StatisticsMetricsViewModelMapper(),
    this.tirMapper = const StatisticsTirViewModelMapper(),
    this.agpMapper = const StatisticsAgpViewModelMapper(),
    this.heatmapMapper = const StatisticsHeatmapViewModelMapper(),
  });

  StatisticsViewModel map(
    StatisticsEngineOutput output, {
    StatisticsLocalizations? l10n,
  }) {
    final strings = l10n ?? StatisticsL10nResolver.fallback;
    final textContext = PluginTextRenderContext(locale: strings.localeName);
    final period = output.periodSection;
    final windowLabel = _windowShortLabel(period.selectedWindow.id, strings);
    final displayWindow = period.rangeLabel ??
        _windowHeaderLabel(period.selectedWindow.id, strings);
    return StatisticsViewModel(
      selectedWindowId: period.selectedWindow.id,
      dateFilterLabel: period.rangeLabel ?? windowLabel,
      periodOptions: period.options
          .map(
            (option) => StatisticsPeriodOptionViewModel(
              id: option.id,
              label: _windowShortLabel(option.id, strings),
              selected: option.selected,
            ),
          )
          .toList(growable: false),
      metricsHeader: metricsMapper.header(
        displayWindow,
        context: textContext,
      ),
      metrics: metricsMapper.map(
        section: output.metricsSection,
        settings: output.settings,
        previousWindowLabel: windowLabel,
        l10n: strings,
        context: textContext,
      ),
      tirBreakdown: tirMapper.map(
        section: output.tirBreakdownSection,
        settings: output.settings,
        l10n: strings,
        context: textContext,
      ),
      agp: agpMapper.map(
        section: output.agpSection,
        settings: output.settings,
        l10n: strings,
        context: textContext,
      ),
      heatmap: heatmapMapper.map(
        output.heatmapSection,
        context: textContext,
      ),
    );
  }

  String _windowShortLabel(
    StatisticsAnalysisWindowId id,
    StatisticsLocalizations l10n,
  ) {
    return switch (id) {
      StatisticsAnalysisWindowId.last24Hours => l10n.windowShortLast24Hours,
      StatisticsAnalysisWindowId.last3Days => l10n.windowShortLast3Days,
      StatisticsAnalysisWindowId.last7Days => l10n.windowShortLast7Days,
      StatisticsAnalysisWindowId.last14Days => l10n.windowShortLast14Days,
      StatisticsAnalysisWindowId.last30Days => l10n.windowShortLast30Days,
      StatisticsAnalysisWindowId.last90Days => l10n.windowShortLast90Days,
    };
  }

  String _windowHeaderLabel(
    StatisticsAnalysisWindowId id,
    StatisticsLocalizations l10n,
  ) {
    return switch (id) {
      StatisticsAnalysisWindowId.last24Hours => l10n.windowHeaderLast24Hours,
      StatisticsAnalysisWindowId.last3Days => l10n.windowHeaderLast3Days,
      StatisticsAnalysisWindowId.last7Days => l10n.windowHeaderLast7Days,
      StatisticsAnalysisWindowId.last14Days => l10n.windowHeaderLast14Days,
      StatisticsAnalysisWindowId.last30Days => l10n.windowHeaderLast30Days,
      StatisticsAnalysisWindowId.last90Days => l10n.windowHeaderLast90Days,
    };
  }
}
