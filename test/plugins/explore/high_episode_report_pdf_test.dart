import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_repeat_chart_dataset.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_repeat_day_mark.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/episode_repeat_time_block_bucket.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/high/high_episode_report_filename_builder.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/high/high_episode_report_payloads.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/high/high_episode_report_section_keys.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/reports/rendering/high/high_episode_report_pdf_renderer.dart';
import 'package:smart_xdrip/reporting/application/report_privacy_policy.dart';
import 'package:smart_xdrip/reporting/domain/report_data_quality_summary.dart';
import 'package:smart_xdrip/reporting/domain/report_date_range.dart';
import 'package:smart_xdrip/reporting/domain/report_disclaimer.dart';
import 'package:smart_xdrip/reporting/domain/report_section.dart';
import 'package:smart_xdrip/reporting/domain/report_section_type.dart';
import 'package:smart_xdrip/reporting/domain/report_snapshot.dart';

void main() {
  test('high episode report renderer generates non-empty pdf bytes', () async {
    final snapshot = _snapshot();
    final bytes = await const HighEpisodeReportPdfRenderer().build(snapshot);

    expect(bytes.length, greaterThan(500));
  });

  test('high episode report filename uses episode timestamp', () {
    final filename = const HighEpisodeReportFilenameBuilder().build(
      DateTime(2026, 6, 18, 8, 23),
    );

    expect(filename, 'solgoinsight-high-episode-report-20260618-0823.pdf');
  });

  test('report privacy policy masks urls and secrets', () {
    expect(
      const ReportPrivacyPolicy().sourceLabel('https://example/api?token=abc'),
      'Configured source',
    );
    expect(const ReportPrivacyPolicy().sourceLabel('secret-token'),
        'Configured source');
  });
}

ReportSnapshot _snapshot() {
  final start = DateTime(2026, 6, 18, 7, 30);
  final peak = DateTime(2026, 6, 18, 8, 23);
  final end = DateTime(2026, 6, 18, 9, 10);
  final readings = [
    GlucoseReading(timestamp: start, value: 8.4),
    GlucoseReading(
        timestamp: start.add(const Duration(minutes: 20)), value: 10.8),
    GlucoseReading(timestamp: peak, value: 14.2),
    GlucoseReading(timestamp: end, value: 9.6),
  ];
  return ReportSnapshot(
    reportId: 'test.high.episode',
    title: 'High Episode Report',
    range: ReportDateRange(start: start, end: end),
    generatedAt: DateTime(2026, 6, 18, 10),
    sourceLabel: 'Nightscout',
    unit: GlucoseUnit.mmolL,
    dataQuality: const ReportDataQualitySummary(
      label: 'High confidence',
      coveragePercent: 92,
      readingCount: 72,
      largestGapMinutes: 10,
    ),
    findings: const [],
    disclaimer: const ReportDisclaimer(
      'This report is observational and is not medical advice.',
    ),
    sections: [
      ReportSection(
        id: '01',
        title: 'High exposure summary',
        type: ReportSectionType.metricGrid,
        rendererKey: HighEpisodeReportSectionKeys.exposureSummary,
        payload: const HighEpisodeExposureSummaryPayload(
          metrics: [
            HighEpisodeReportMetric(
                label: 'High episodes',
                value: '3',
                note: 'past window',
                tone: 'rose'),
            HighEpisodeReportMetric(
                label: 'Time above range',
                value: '18%',
                note: 'episode day',
                tone: 'amber'),
            HighEpisodeReportMetric(
                label: 'Highest peak',
                value: '14.2',
                note: 'mmol/L',
                tone: 'rose'),
            HighEpisodeReportMetric(
                label: 'Median return',
                value: '47m',
                note: 'visible recovery',
                tone: 'green'),
          ],
        ),
      ),
      ReportSection(
        id: '02',
        title: 'Representative episode curve',
        type: ReportSectionType.chart,
        rendererKey: HighEpisodeReportSectionKeys.curve,
        payload: HighEpisodeCurvePayload(
          readings: readings,
          unit: GlucoseUnit.mmolL,
          highThresholdMmol: 10,
          veryHighThresholdMmol: 13.9,
          onsetTime: start,
          peakTime: peak,
          returnTime: end,
          timeRangeStart: start,
          timeRangeEnd: end,
          peakLabel: '14.2 mmol/L',
          durationAboveRangeLabel: '75m',
          veryHighMinutesLabel: '20m',
          returnLabel: '09:10',
        ),
      ),
      ReportSection(
        id: '03',
        title: 'Episode lifecycle',
        type: ReportSectionType.timeline,
        rendererKey: HighEpisodeReportSectionKeys.lifecycle,
        payload: const HighEpisodeLifecyclePayload(
          steps: [
            HighEpisodeLifecycleStepPayload(
                code: 'B', label: 'Baseline', value: '8.4', tone: 'green'),
            HighEpisodeLifecycleStepPayload(
                code: 'R', label: 'Rise', value: '+0.08/min', tone: 'amber'),
            HighEpisodeLifecycleStepPayload(
                code: 'P', label: 'Peak', value: '14.2', tone: 'rose'),
            HighEpisodeLifecycleStepPayload(
                code: 'D', label: 'Duration', value: '75m', tone: 'amber'),
            HighEpisodeLifecycleStepPayload(
                code: 'RT', label: 'Return', value: '09:10', tone: 'green'),
          ],
        ),
      ),
      ReportSection(
        id: '04',
        title: 'Repeat pattern',
        type: ReportSectionType.chart,
        rendererKey: HighEpisodeReportSectionKeys.repeat,
        payload: HighEpisodeRepeatPayload(dataset: _repeatDataset(start)),
      ),
      ReportSection(
        id: '05',
        title: 'Review notes',
        type: ReportSectionType.findingList,
        rendererKey: HighEpisodeReportSectionKeys.findings,
        payload: const HighEpisodeFindingListPayload(
          findings: [
            HighEpisodeReportFindingPayload(
              title: 'Main driver',
              body: 'Peak and duration were the main review signals.',
              tone: 'rose',
            ),
          ],
        ),
      ),
      ReportSection(
        id: '06',
        title: 'Data quality',
        type: ReportSectionType.dataQuality,
        rendererKey: HighEpisodeReportSectionKeys.quality,
        payload: const HighEpisodeQualityPayload(
          metrics: [
            HighEpisodeReportMetric(
                label: 'Coverage',
                value: '92%',
                note: 'episode window',
                tone: 'green'),
            HighEpisodeReportMetric(
                label: 'Readings',
                value: '72',
                note: 'visible points',
                tone: 'green'),
            HighEpisodeReportMetric(
                label: 'Largest gap',
                value: '10m',
                note: 'good continuity',
                tone: 'green'),
            HighEpisodeReportMetric(
                label: 'Confidence',
                value: 'High',
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
    repeatCount: 6,
    dominantBlockLabel: 'Morning',
    dominantRangeLabel: '08:00-11:59',
    takeaway: 'High episodes appeared most often in the morning window.',
    dayMarks: [
      for (var i = 0; i < 30; i++)
        EpisodeRepeatDayMark(
          date: anchor.subtract(Duration(days: 29 - i)),
          hasEpisode: i % 5 == 0,
          isCurrent: i == 29,
          isStrong: i % 10 == 0,
        ),
    ],
    timeBlockBuckets: const [
      EpisodeRepeatTimeBlockBucket(
          label: 'Night',
          count: 0,
          normalizedHeight: .05,
          isDominant: false,
          isSecondary: false),
      EpisodeRepeatTimeBlockBucket(
          label: 'Dawn',
          count: 1,
          normalizedHeight: .25,
          isDominant: false,
          isSecondary: true),
      EpisodeRepeatTimeBlockBucket(
          label: 'Morning',
          count: 4,
          normalizedHeight: 1,
          isDominant: true,
          isSecondary: false),
      EpisodeRepeatTimeBlockBucket(
          label: 'Afternoon',
          count: 1,
          normalizedHeight: .25,
          isDominant: false,
          isSecondary: true),
      EpisodeRepeatTimeBlockBucket(
          label: 'Evening',
          count: 0,
          normalizedHeight: .05,
          isDominant: false,
          isSecondary: false),
    ],
  );
}
