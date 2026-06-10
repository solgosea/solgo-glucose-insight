import 'package:smart_xdrip/domain/entities/app_settings.dart';

class SettingsAnalysisResult {
  final AppSettings settings;
  final int? dbBytes;
  final int readingCount;
  final DateTime? earliestReading;
  final DateTime? latestReading;
  final int daysCovered;

  const SettingsAnalysisResult({
    required this.settings,
    required this.dbBytes,
    required this.readingCount,
    required this.earliestReading,
    required this.latestReading,
    required this.daysCovered,
  });
}
