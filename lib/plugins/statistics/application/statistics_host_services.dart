import 'package:flutter/foundation.dart';

import '../../../application/analysis/analysis_facade.dart';
import '../../../domain/entities/app_settings.dart';

class StatisticsHostServices {
  final Listenable changeSignal;
  final AnalysisFacade Function() facadeProvider;
  final AppSettings Function() settingsProvider;

  const StatisticsHostServices({
    required this.changeSignal,
    required this.facadeProvider,
    required this.settingsProvider,
  });
}
