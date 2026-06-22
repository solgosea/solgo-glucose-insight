import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../domain/episode_repeat_chart_dataset.dart';

class LowEpisodeReportMetric {
  final String label;
  final String value;
  final String note;
  final String tone;

  const LowEpisodeReportMetric({
    required this.label,
    required this.value,
    required this.note,
    this.tone = 'neutral',
  });
}

class LowEpisodeExposureSummaryPayload {
  final List<LowEpisodeReportMetric> metrics;

  const LowEpisodeExposureSummaryPayload({
    required this.metrics,
  });
}

class LowEpisodeCurvePayload {
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double lowThresholdMmol;
  final double veryLowThresholdMmol;
  final DateTime onsetTime;
  final DateTime nadirTime;
  final DateTime? recoveryTime;
  final DateTime timeRangeStart;
  final DateTime timeRangeEnd;
  final String nadirLabel;
  final String durationBelowRangeLabel;
  final String veryLowMinutesLabel;
  final String recoveryLabel;

  const LowEpisodeCurvePayload({
    required this.readings,
    required this.unit,
    required this.lowThresholdMmol,
    required this.veryLowThresholdMmol,
    required this.onsetTime,
    required this.nadirTime,
    required this.recoveryTime,
    required this.timeRangeStart,
    required this.timeRangeEnd,
    required this.nadirLabel,
    required this.durationBelowRangeLabel,
    required this.veryLowMinutesLabel,
    required this.recoveryLabel,
  });
}

class LowEpisodeLifecycleStepPayload {
  final String code;
  final String label;
  final String value;
  final String tone;

  const LowEpisodeLifecycleStepPayload({
    required this.code,
    required this.label,
    required this.value,
    required this.tone,
  });
}

class LowEpisodeLifecyclePayload {
  final List<LowEpisodeLifecycleStepPayload> steps;

  const LowEpisodeLifecyclePayload({
    required this.steps,
  });
}

class LowEpisodeRepeatPayload {
  final EpisodeRepeatChartDataset dataset;

  const LowEpisodeRepeatPayload({
    required this.dataset,
  });
}

class LowEpisodeFindingListPayload {
  final List<LowEpisodeReportFindingPayload> findings;

  const LowEpisodeFindingListPayload({
    required this.findings,
  });
}

class LowEpisodeReportFindingPayload {
  final String title;
  final String body;
  final String tone;

  const LowEpisodeReportFindingPayload({
    required this.title,
    required this.body,
    required this.tone,
  });
}

class LowEpisodeQualityPayload {
  final List<LowEpisodeReportMetric> metrics;

  const LowEpisodeQualityPayload({
    required this.metrics,
  });
}
