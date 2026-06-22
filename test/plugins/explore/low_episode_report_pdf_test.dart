import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_repeat_chart_dataset.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_repeat_day_mark.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_repeat_time_block_bucket.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/low/low_episode_report_filename_builder.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/low/low_episode_report_payloads.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/low/low_episode_report_section_keys.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/rendering/low/low_episode_report_pdf_renderer.dart';
import 'package:smart_xdrip/reporting/domain/report_data_quality_summary.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_disclaimer.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_section_type.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

void main() {
  test('low episode report renderer generates non-empty pdf bytes', () async {
    final snapshot = _snapshot();
    final bytes = await const LowEpisodeReportPdfRenderer().build(snapshot);

    expect(bytes.length, greaterThan(500));
  });

  test('low episode report filename uses episode timestamp', () {
    final filename = const LowEpisodeReportFilenameBuilder().build(
      DateTime(2026, 6, 18, 2, 10),
    );

    expect(filename, 'solgoinsight-low-episode-report-20260618-0210.pdf');
  });

  test('low episode report omits similar section and numeric section ids', () {
    final snapshot = _snapshot();

    expect(snapshot.sections.map((section) => section.title),
        isNot(contains('Similar episodes')));
    expect(
        snapshot.sections.map((section) => section.id), isNot(contains('01')));
  });
}

ReportSnapshot _snapshot() {
  final start = DateTime(2026, 6, 18, 1, 30);
  final nadir = DateTime(2026, 6, 18, 2, 10);
  final end = DateTime(2026, 6, 18, 3, 2);
  final readings = [
    GlucoseReading(timestamp: start, value: 6.8),
    GlucoseReading(
        timestamp: start.add(const Duration(minutes: 20)), value: 4.1),
    GlucoseReading(timestamp: nadir, value: 3.1),
    GlucoseReading(timestamp: end, value: 4.3),
  ];
  return ReportSnapshot(
    reportId: 'test.low.episode',
    title: 'Low Episode Report',
    range: ReportDateRange(start: start, end: end),
    generatedAt: DateTime(2026, 6, 18, 10),
    sourceLabel: 'xDrip+ Local',
    unit: GlucoseUnit.mmolL,
    dataQuality: const ReportDataQualitySummary(
      label: 'Representative',
      coveragePercent: 92,
      readingCount: 44,
      largestGapMinutes: 10,
    ),
    findings: const [],
    disclaimer: const ReportDisclaimer(
      'This report is observational and is not medical advice.',
    ),
    sections: [
      ReportSection(
        id: 'summary',
        title: 'Low exposure summary',
        type: ReportSectionType.metricGrid,
        rendererKey: LowEpisodeReportSectionKeys.exposureSummary,
        payload: const LowEpisodeExposureSummaryPayload(
          metrics: [
            LowEpisodeReportMetric(
                label: 'Low episodes',
                value: '4',
                note: 'past window',
                tone: 'blue'),
            LowEpisodeReportMetric(
                label: 'Time below range',
                value: '5%',
                note: 'episode window',
                tone: 'blue'),
            LowEpisodeReportMetric(
                label: 'Lowest value',
                value: '3.1',
                note: 'mmol/L',
                tone: 'blue'),
            LowEpisodeReportMetric(
                label: 'Median recovery',
                value: '52m',
                note: 'visible recovery',
                tone: 'green'),
          ],
        ),
      ),
      ReportSection(
        id: 'curve',
        title: 'Representative episode curve',
        type: ReportSectionType.chart,
        rendererKey: LowEpisodeReportSectionKeys.curve,
        payload: LowEpisodeCurvePayload(
          readings: readings,
          unit: GlucoseUnit.mmolL,
          lowThresholdMmol: 3.9,
          veryLowThresholdMmol: 3.0,
          onsetTime: start,
          nadirTime: nadir,
          recoveryTime: end,
          timeRangeStart: start,
          timeRangeEnd: end,
          nadirLabel: '3.1 mmol/L',
          durationBelowRangeLabel: '44m',
          veryLowMinutesLabel: '0m',
          recoveryLabel: '03:02',
        ),
      ),
      ReportSection(
        id: 'lifecycle',
        title: 'Episode lifecycle',
        type: ReportSectionType.timeline,
        rendererKey: LowEpisodeReportSectionKeys.lifecycle,
        payload: const LowEpisodeLifecyclePayload(
          steps: [
            LowEpisodeLifecycleStepPayload(
                code: 'B', label: 'Baseline', value: '6.8', tone: 'green'),
            LowEpisodeLifecycleStepPayload(
                code: 'D', label: 'Descent', value: '-0.08/min', tone: 'amber'),
            LowEpisodeLifecycleStepPayload(
                code: 'N', label: 'Nadir', value: '3.1', tone: 'blue'),
            LowEpisodeLifecycleStepPayload(
                code: 'L', label: 'Low time', value: '44m', tone: 'blue'),
            LowEpisodeLifecycleStepPayload(
                code: 'OK', label: 'Recovery', value: '03:02', tone: 'green'),
          ],
        ),
      ),
      ReportSection(
        id: 'repeat',
        title: 'Repeat pattern',
        type: ReportSectionType.chart,
        rendererKey: LowEpisodeReportSectionKeys.repeat,
        payload: LowEpisodeRepeatPayload(dataset: _repeatDataset(start)),
      ),
      ReportSection(
        id: 'findings',
        title: 'Review notes',
        type: ReportSectionType.findingList,
        rendererKey: LowEpisodeReportSectionKeys.findings,
        payload: const LowEpisodeFindingListPayload(
          findings: [
            LowEpisodeReportFindingPayload(
              title: 'Main driver',
              body: 'Fast descent was the main review signal.',
              tone: 'blue',
            ),
          ],
        ),
      ),
      ReportSection(
        id: 'quality',
        title: 'Data quality',
        type: ReportSectionType.dataQuality,
        rendererKey: LowEpisodeReportSectionKeys.quality,
        payload: const LowEpisodeQualityPayload(
          metrics: [
            LowEpisodeReportMetric(
                label: 'Coverage',
                value: '92%',
                note: 'episode window',
                tone: 'green'),
            LowEpisodeReportMetric(
                label: 'Readings',
                value: '44',
                note: 'visible points',
                tone: 'green'),
            LowEpisodeReportMetric(
                label: 'Largest gap',
                value: '10m',
                note: 'good continuity',
                tone: 'green'),
            LowEpisodeReportMetric(
                label: 'Confidence',
                value: 'Representative',
                note: 'report quality',
                tone: 'green'),
          ],
        ),
      ),
    ],
  );
}

EpisodeRepeatChartDataset _repeatDataset(DateTime anchor) {
  return EpisodeRepeatChartDataset(
    windowDays: 30,
    repeatCount: 4,
    dominantBlockLabel: 'Night',
    dominantRangeLabel: '00:00-05:59',
    takeaway: 'Low episodes appeared most often overnight.',
    dayMarks: [
      for (var i = 0; i < 30; i++)
        EpisodeRepeatDayMark(
          date: anchor.subtract(Duration(days: 29 - i)),
          hasEpisode: i % 7 == 0,
          isCurrent: i == 29,
          isStrong: i % 14 == 0,
        ),
    ],
    timeBlockBuckets: const [
      EpisodeRepeatTimeBlockBucket(
          label: 'Night',
          count: 4,
          normalizedHeight: 1,
          isDominant: true,
          isSecondary: false),
      EpisodeRepeatTimeBlockBucket(
          label: 'Dawn',
          count: 2,
          normalizedHeight: .5,
          isDominant: false,
          isSecondary: true),
      EpisodeRepeatTimeBlockBucket(
          label: 'Morning',
          count: 1,
          normalizedHeight: .25,
          isDominant: false,
          isSecondary: false),
      EpisodeRepeatTimeBlockBucket(
          label: 'Afternoon',
          count: 0,
          normalizedHeight: .05,
          isDominant: false,
          isSecondary: false),
      EpisodeRepeatTimeBlockBucket(
          label: 'Evening',
          count: 0,
          normalizedHeight: .05,
          isDominant: false,
          isSecondary: false),
    ],
  );
}
