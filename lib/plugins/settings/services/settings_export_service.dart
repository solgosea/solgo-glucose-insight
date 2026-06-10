import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class SettingsExportService {
  final GlucoseUnitFormatService glucoseFormatter;

  const SettingsExportService({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  Future<String?> exportReadingsCsv(
    List<GlucoseReading> readings, {
    required GlucoseUnit unit,
  }) async {
    if (readings.isEmpty) return null;
    final csv = _readingsToCsv(readings, unit);
    final dir = await getApplicationDocumentsDirectory();
    final stamp = _fileStamp(DateTime.now());
    final path = p.join(dir.path, 'cgm_export_$stamp.csv');
    final file = File(path);
    await file.writeAsString(csv, flush: true);
    return path;
  }

  String _readingsToCsv(List<GlucoseReading> readings, GlucoseUnit unit) {
    final unitKey = switch (unit) {
      GlucoseUnit.mmolL => 'mmol_per_l',
      GlucoseUnit.mgDl => 'mg_per_dl',
    };
    final buffer =
        StringBuffer()
          ..writeln('timestamp_iso,$unitKey,trend_${unitKey}_per_min');
    for (final reading in readings) {
      final iso = reading.timestamp.toUtc().toIso8601String();
      final value = glucoseFormatter.value(reading.value, unit).valueLabel;
      final trend =
          reading.ratePerMin == null
              ? ''
              : glucoseFormatter.rate(reading.ratePerMin!, unit).valueLabel;
      buffer.writeln('$iso,$value,$trend');
    }
    return buffer.toString();
  }

  String _fileStamp(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${time.year}${two(time.month)}${two(time.day)}_'
        '${two(time.hour)}${two(time.minute)}';
  }
}
