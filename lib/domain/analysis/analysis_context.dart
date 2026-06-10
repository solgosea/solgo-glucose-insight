import '../entities/app_settings.dart';
import '../entities/glucose_reading.dart';
import 'analysis_window.dart';

class AnalysisContext {
  final AnalysisWindow window;
  final AppSettings settings;
  final List<GlucoseReading> readings;

  const AnalysisContext({
    required this.window,
    required this.settings,
    required this.readings,
  });

  bool get hasEnoughReadings => readings.length >= 12;
}
