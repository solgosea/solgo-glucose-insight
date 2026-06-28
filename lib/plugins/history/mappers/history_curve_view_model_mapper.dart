import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../foundation/theme/app_colors.dart';
import '../../../presentation/common/widgets/charts/glucose_line_chart.dart';
import '../domain/sections/history_curve_section.dart';
import '../models/history_view_model.dart';

class HistoryCurveViewModelMapper {
  const HistoryCurveViewModelMapper();

  HistoryCurveViewModel map(
    HistoryCurveSection section,
    AppSettings settings,
  ) {
    return HistoryCurveViewModel(
      readings: section.dataset.readings,
      unit: settings.unit,
      lowThreshold: settings.lowThreshold,
      highThreshold: settings.highThreshold,
      timeRangeStart: section.dataset.rangeStart,
      timeRangeEnd: section.dataset.rangeEnd.add(const Duration(days: 1)),
      episodes: _chartEpisodes(section.dataset.events),
      markers: _chartMarkers(section.dataset.events),
    );
  }

  List<ChartEpisode> _chartEpisodes(List<GlucoseEvent> events) {
    final output = <ChartEpisode>[];
    for (final event in events) {
      final end = event.endTime;
      if (end == null) continue;
      if (event.type == GlucoseEventType.highEpisode) {
        output.add(
          ChartEpisode(start: event.time, end: end, color: AppColors.rose),
        );
      } else if (event.type == GlucoseEventType.lowEpisode) {
        output.add(
          ChartEpisode(start: event.time, end: end, color: AppColors.blue),
        );
      }
    }
    return output;
  }

  List<ChartEventMarker> _chartMarkers(List<GlucoseEvent> events) {
    final output = <ChartEventMarker>[];
    for (final event in events) {
      switch (event.type) {
        case GlucoseEventType.rise:
          output
              .add(ChartEventMarker(time: event.time, color: AppColors.amber));
          break;
        case GlucoseEventType.highEpisode:
          output.add(ChartEventMarker(time: event.time, color: AppColors.rose));
          break;
        case GlucoseEventType.lowEpisode:
          output.add(ChartEventMarker(time: event.time, color: AppColors.blue));
          break;
        case GlucoseEventType.recovery:
          output
              .add(ChartEventMarker(time: event.time, color: AppColors.green));
          break;
        case GlucoseEventType.stableWindow:
        case GlucoseEventType.firstReading:
        case GlucoseEventType.dawnPhenomenon:
          break;
      }
    }
    return output;
  }
}
