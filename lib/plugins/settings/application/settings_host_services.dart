import 'package:flutter/foundation.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_reading.dart';

class SettingsHostServices {
  final Listenable changeSignal;
  final AppSettings Function() settingsProvider;
  final Future<int?> Function() databaseFileSizeBytes;
  final Future<List<GlucoseReading>> Function(int days) readingsForDays;

  const SettingsHostServices({
    required this.changeSignal,
    required this.settingsProvider,
    required this.databaseFileSizeBytes,
    required this.readingsForDays,
  });
}
