import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../domain/statistics_analysis_window.dart';

class StatisticsEngineInput {
  final StatisticsAnalysisWindow selectedWindow;
  final List<StatisticsAnalysisWindow> windows;
  final String? rangeLabel;
  final List<GlucoseReading> currentReadings;
  final List<GlucoseReading> previousReadings;
  final AppSettings settings;

  const StatisticsEngineInput({
    required this.selectedWindow,
    required this.windows,
    this.rangeLabel,
    required this.currentReadings,
    required this.previousReadings,
    required this.settings,
  });
}
