import '../domain/statistics_analysis_window_catalog.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../domain/statistics_date_filter.dart';
import '../engine/statistics_engine.dart';
import '../engine/statistics_engine_input.dart';
import '../engine/statistics_engine_output.dart';
import 'statistics_host_services.dart';
import 'statistics_window_reader.dart';

class StatisticsService {
  final StatisticsHostServices hostServices;
  final StatisticsWindowReader windowReader;
  final StatisticsEngine engine;

  const StatisticsService({
    required this.hostServices,
    this.windowReader = const StatisticsWindowReader(),
    this.engine = const StatisticsEngine(),
  });

  StatisticsEngineOutput load({
    required StatisticsAnalysisWindowId windowId,
    StatisticsDateFilter? dateFilter,
    String? rangeLabel,
  }) {
    final facade = hostServices.facadeProvider();
    final window = StatisticsAnalysisWindowCatalog.byId(windowId);
    final useRollingWindow = dateFilter == null || dateFilter.isPresetWindow;
    return engine.run(
      StatisticsEngineInput(
        selectedWindow: window,
        windows: StatisticsAnalysisWindowCatalog.all,
        rangeLabel: rangeLabel,
        currentReadings: useRollingWindow
            ? windowReader.readingsForWindow(facade, window)
            : windowReader.readingsForSelection(
                facade,
                start: dateFilter.selection.start,
                end: dateFilter.selection.end,
              ),
        previousReadings: useRollingWindow
            ? windowReader.previousReadingsForWindow(facade, window)
            : windowReader.previousReadingsForSelection(
                facade,
                start: dateFilter.selection.start,
                end: dateFilter.selection.end,
              ),
        settings: facade.settings,
      ),
    );
  }
}
