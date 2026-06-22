import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../domain/episode_repeat_chart_dataset.dart';
import '../../domain/episode_similar_chart_point.dart';

class HighEpisodeReportMetric {
  final String label;
  final String value;
  final String note;
  final String tone;

  const HighEpisodeReportMetric({
    required this.label,
    required this.value,
    required this.note,
    this.tone = 'neutral',
  });
}

class HighEpisodeExposureSummaryPayload {
  final List<HighEpisodeReportMetric> metrics;

  const HighEpisodeExposureSummaryPayload({
    required this.metrics,
  });
}

class HighEpisodeCurvePayload {
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double highThresholdMmol;
  final double veryHighThresholdMmol;
  final DateTime onsetTime;
  final DateTime peakTime;
  final DateTime? returnTime;
  final DateTime timeRangeStart;
  final DateTime timeRangeEnd;
  final String peakLabel;
  final String durationAboveRangeLabel;
  final String veryHighMinutesLabel;
  final String returnLabel;

  const HighEpisodeCurvePayload({
    required this.readings,
    required this.unit,
    required this.highThresholdMmol,
    required this.veryHighThresholdMmol,
    required this.onsetTime,
    required this.peakTime,
    required this.returnTime,
    required this.timeRangeStart,
    required this.timeRangeEnd,
    required this.peakLabel,
    required this.durationAboveRangeLabel,
    required this.veryHighMinutesLabel,
    required this.returnLabel,
  });
}

class HighEpisodeLifecycleStepPayload {
  final String code;
  final String label;
  final String value;
  final String tone;

  const HighEpisodeLifecycleStepPayload({
    required this.code,
    required this.label,
    required this.value,
    required this.tone,
  });
}

class HighEpisodeLifecyclePayload {
  final List<HighEpisodeLifecycleStepPayload> steps;

  const HighEpisodeLifecyclePayload({
    required this.steps,
  });
}

class HighEpisodeRepeatPayload {
  final EpisodeRepeatChartDataset dataset;

  const HighEpisodeRepeatPayload({
    required this.dataset,
  });
}

class HighEpisodeSimilarPayload {
  final int windowDays;
  final List<EpisodeSimilarChartPoint> points;
  final int similarCount;
  final String medianPeakLabel;
  final String medianDurationLabel;

  const HighEpisodeSimilarPayload({
    required this.windowDays,
    required this.points,
    required this.similarCount,
    required this.medianPeakLabel,
    required this.medianDurationLabel,
  });
}

class HighEpisodeFindingListPayload {
  final List<HighEpisodeReportFindingPayload> findings;

  const HighEpisodeFindingListPayload({
    required this.findings,
  });
}

class HighEpisodeReportFindingPayload {
  final String title;
  final String body;
  final String tone;

  const HighEpisodeReportFindingPayload({
    required this.title,
    required this.body,
    required this.tone,
  });
}

class HighEpisodeQualityPayload {
  final List<HighEpisodeReportMetric> metrics;

  const HighEpisodeQualityPayload({
    required this.metrics,
  });
}
