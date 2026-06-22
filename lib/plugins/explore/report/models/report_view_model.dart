import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';
import 'report_period.dart';
import 'report_section.dart';

class ReportPeriodOption {
  final ReportPeriod period;
  final bool selected;

  const ReportPeriodOption({
    required this.period,
    required this.selected,
  });
}

class ReportMetricViewModel {
  final String label;
  final String value;
  final String unit;
  final String? badge;
  final ReportMetricTone tone;

  const ReportMetricViewModel({
    required this.label,
    required this.value,
    required this.unit,
    this.badge,
    this.tone = ReportMetricTone.neutral,
  });
}

enum ReportMetricTone { green, amber, blue, neutral }

class ReportDataQualityViewModel {
  final double wearPercent;
  final int activeMinutes;
  final int expectedMinutes;
  final int readingCount;
  final int duplicateCount;
  final int gapCount;

  const ReportDataQualityViewModel({
    required this.wearPercent,
    required this.activeMinutes,
    required this.expectedMinutes,
    required this.readingCount,
    required this.duplicateCount,
    required this.gapCount,
  });
}

class ReportRangeViewModel {
  final String label;
  final String thresholdLabel;
  final String? levelLabel;
  final double percent;
  final int minutesPerDay;
  final ReportRangeTone tone;

  const ReportRangeViewModel({
    required this.label,
    required this.thresholdLabel,
    this.levelLabel,
    required this.percent,
    required this.minutesPerDay,
    required this.tone,
  });
}

enum ReportRangeTone { veryHigh, high, inRange, low, veryLow }

class ReportDailyCurveViewModel {
  final DateTime day;
  final String dayLabel;
  final double? tir;
  final List<GlucoseReading> readings;
  final bool sparse;

  const ReportDailyCurveViewModel({
    required this.day,
    required this.dayLabel,
    required this.tir,
    required this.readings,
    required this.sparse,
  });
}

class ReportHeaderViewModel {
  final String periodTitle;
  final String periodLabel;
  final String readingsLabel;
  final String coverageLabel;
  final String dataSourceTitle;
  final String dataSourceLabel;
  final String targetRangeTitle;
  final String targetRangeLabel;
  final String generatedTitle;
  final String generatedLabel;

  const ReportHeaderViewModel({
    required this.periodTitle,
    required this.periodLabel,
    required this.readingsLabel,
    required this.coverageLabel,
    required this.dataSourceTitle,
    required this.dataSourceLabel,
    required this.targetRangeTitle,
    required this.targetRangeLabel,
    required this.generatedTitle,
    required this.generatedLabel,
  });
}

class ReportPeriodAnalysisViewModel {
  final bool hasData;
  final String summaryText;
  final List<ReportPeriodRowViewModel> rows;

  const ReportPeriodAnalysisViewModel({
    required this.hasData,
    required this.summaryText,
    required this.rows,
  });
}

class ReportPeriodRowViewModel {
  final String label;
  final String averageLabel;
  final String tirLabel;
  final String cvLabel;
  final String peakLabel;

  const ReportPeriodRowViewModel({
    required this.label,
    required this.averageLabel,
    required this.tirLabel,
    required this.cvLabel,
    required this.peakLabel,
  });
}

class ReportEpisodesSummaryViewModel {
  final bool hasData;
  final int highCount;
  final int lowCount;
  final String avgHighDurationLabel;
  final String avgLowDurationLabel;
  final int nocturnalLowCount;
  final String highestLabel;
  final String lowestLabel;
  final String summaryText;

  const ReportEpisodesSummaryViewModel({
    required this.hasData,
    required this.highCount,
    required this.lowCount,
    required this.avgHighDurationLabel,
    required this.avgLowDurationLabel,
    required this.nocturnalLowCount,
    required this.highestLabel,
    required this.lowestLabel,
    required this.summaryText,
  });
}

class ReportViewModel {
  final ReportPeriod selectedPeriod;
  final List<ReportPeriodOption> periodOptions;
  final ReportHeaderViewModel header;
  final List<ReportMetricViewModel> metrics;
  final List<ReportRangeViewModel> ranges;
  final List<AnalysisAgpSlot> agpSlots;
  final List<ReportDailyCurveViewModel> dailyCurves;
  final ReportDataQualityViewModel dataQuality;
  final ReportPeriodAnalysisViewModel periodAnalysis;
  final ReportEpisodesSummaryViewModel episodesSummary;
  final List<ReportSectionToggle> sections;
  final AppSettings settings;
  final bool hasData;
  final String emptyText;

  const ReportViewModel({
    required this.selectedPeriod,
    required this.periodOptions,
    required this.header,
    required this.metrics,
    required this.ranges,
    required this.agpSlots,
    required this.dailyCurves,
    required this.dataQuality,
    required this.periodAnalysis,
    required this.episodesSummary,
    required this.sections,
    required this.settings,
    required this.hasData,
    required this.emptyText,
  });

  ReportViewModel copyWith({
    ReportPeriod? selectedPeriod,
    List<ReportPeriodOption>? periodOptions,
    ReportHeaderViewModel? header,
    List<ReportMetricViewModel>? metrics,
    List<ReportRangeViewModel>? ranges,
    List<AnalysisAgpSlot>? agpSlots,
    List<ReportDailyCurveViewModel>? dailyCurves,
    ReportDataQualityViewModel? dataQuality,
    ReportPeriodAnalysisViewModel? periodAnalysis,
    ReportEpisodesSummaryViewModel? episodesSummary,
    List<ReportSectionToggle>? sections,
    AppSettings? settings,
    bool? hasData,
    String? emptyText,
  }) =>
      ReportViewModel(
        selectedPeriod: selectedPeriod ?? this.selectedPeriod,
        periodOptions: periodOptions ?? this.periodOptions,
        header: header ?? this.header,
        metrics: metrics ?? this.metrics,
        ranges: ranges ?? this.ranges,
        agpSlots: agpSlots ?? this.agpSlots,
        dailyCurves: dailyCurves ?? this.dailyCurves,
        dataQuality: dataQuality ?? this.dataQuality,
        periodAnalysis: periodAnalysis ?? this.periodAnalysis,
        episodesSummary: episodesSummary ?? this.episodesSummary,
        sections: sections ?? this.sections,
        settings: settings ?? this.settings,
        hasData: hasData ?? this.hasData,
        emptyText: emptyText ?? this.emptyText,
      );
}
