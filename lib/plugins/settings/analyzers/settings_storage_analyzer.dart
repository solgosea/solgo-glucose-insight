import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../models/settings_analysis_result.dart';

class SettingsStorageAnalyzer {
  const SettingsStorageAnalyzer();

  Future<SettingsAnalysisResult> analyze({
    required AppSettings settings,
    required Future<int?> Function() databaseFileSizeBytes,
    required Future<List<GlucoseReading>> Function(int days) readingsForDays,
  }) async {
    final bytes = await databaseFileSizeBytes();
    final readings = await readingsForDays(settings.retentionDays);
    final earliest = readings.isEmpty ? null : readings.first.timestamp;
    final latest = readings.isEmpty ? null : readings.last.timestamp;
    final daysCovered = _daysCovered(
      earliest: earliest,
      latest: latest,
      retentionDays: settings.retentionDays,
    );

    return SettingsAnalysisResult(
      settings: settings,
      dbBytes: bytes,
      readingCount: readings.length,
      earliestReading: earliest,
      latestReading: latest,
      daysCovered: daysCovered,
    );
  }

  int _daysCovered({
    required DateTime? earliest,
    required DateTime? latest,
    required int retentionDays,
  }) {
    if (earliest == null || latest == null) return 0;
    final span = latest.difference(earliest).inDays + 1;
    return span.clamp(0, retentionDays).toInt();
  }
}
