import 'calculators/history_curve_dataset_calculator.dart';
import 'calculators/history_episode_filter_calculator.dart';
import 'calculators/history_event_filter_calculator.dart';
import 'calculators/history_stats_calculator.dart';
import 'calculators/history_summary_calculator.dart';
import 'history_engine_input.dart';
import 'history_engine_output.dart';
import 'section_builders/history_curve_section_builder.dart';
import 'section_builders/history_date_section_builder.dart';
import 'section_builders/history_episode_section_builder.dart';
import 'section_builders/history_events_section_builder.dart';
import 'section_builders/history_stats_section_builder.dart';
import 'section_builders/history_summary_section_builder.dart';

class HistoryEngine {
  final HistorySummaryCalculator summaryCalculator;
  final HistoryStatsCalculator statsCalculator;
  final HistoryCurveDatasetCalculator curveDatasetCalculator;
  final HistoryEpisodeFilterCalculator episodeFilterCalculator;
  final HistoryEventFilterCalculator eventFilterCalculator;
  final HistoryDateSectionBuilder dateSectionBuilder;
  final HistorySummarySectionBuilder summarySectionBuilder;
  final HistoryCurveSectionBuilder curveSectionBuilder;
  final HistoryStatsSectionBuilder statsSectionBuilder;
  final HistoryEpisodeSectionBuilder episodeSectionBuilder;
  final HistoryEventsSectionBuilder eventsSectionBuilder;

  const HistoryEngine({
    this.summaryCalculator = const HistorySummaryCalculator(),
    this.statsCalculator = const HistoryStatsCalculator(),
    this.curveDatasetCalculator = const HistoryCurveDatasetCalculator(),
    this.episodeFilterCalculator = const HistoryEpisodeFilterCalculator(),
    this.eventFilterCalculator = const HistoryEventFilterCalculator(),
    this.dateSectionBuilder = const HistoryDateSectionBuilder(),
    this.summarySectionBuilder = const HistorySummarySectionBuilder(),
    this.curveSectionBuilder = const HistoryCurveSectionBuilder(),
    this.statsSectionBuilder = const HistoryStatsSectionBuilder(),
    this.episodeSectionBuilder = const HistoryEpisodeSectionBuilder(),
    this.eventsSectionBuilder = const HistoryEventsSectionBuilder(),
  });

  HistoryEngineOutput run(HistoryEngineInput input) {
    final summaryFacts = summaryCalculator.calculate(
      tir: input.tir,
      readings: input.readings,
    );
    final statsFacts = statsCalculator.calculate(
      tir: input.tir,
      readings: input.readings,
    );
    final curveDataset = curveDatasetCalculator.calculate(
      selectedDay: input.selectedDay,
      rangeStart: input.rangeStart,
      rangeEnd: input.rangeEnd,
      readings: input.readings,
      events: input.events,
    );
    final filteredEpisodes = episodeFilterCalculator.calculate(
      input.events,
      input.timeFilter,
    );
    final filteredEvents = eventFilterCalculator.calculate(
      input.events,
      input.timeFilter,
    );

    return HistoryEngineOutput(
      settings: input.settings,
      timeFilter: input.timeFilter,
      dateSection: dateSectionBuilder.build(
        selectedDay: input.selectedDay,
        rangeStart: input.rangeStart,
        rangeEnd: input.rangeEnd,
        isToday: input.isToday,
      ),
      summarySection: summarySectionBuilder.build(
        tir: summaryFacts.tir,
        readings: summaryFacts.readings,
      ),
      curveSection: curveSectionBuilder.build(curveDataset),
      statsSection: statsSectionBuilder.build(
        tir: statsFacts.tir,
        readings: statsFacts.readings,
      ),
      episodeSection: episodeSectionBuilder.build(
        events: filteredEpisodes,
        filter: input.timeFilter,
      ),
      eventsSection: eventsSectionBuilder.build(
        events: filteredEvents,
        filter: input.timeFilter,
      ),
    );
  }
}
