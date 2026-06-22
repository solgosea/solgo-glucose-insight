import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/history/application/history_service.dart';
import 'package:smart_xdrip/plugins/history/l10n/generated/history_localizations_zh.dart';

void main() {
  test('history view model maps visible copy in Chinese', () {
    final day = DateTime(2026, 6, 6);
    final readings = [
      GlucoseReading(timestamp: day.add(const Duration(hours: 8)), value: 6.2),
      GlucoseReading(timestamp: day.add(const Duration(hours: 9)), value: 11.4),
      GlucoseReading(
        timestamp: day.add(const Duration(hours: 10)),
        value: 12.1,
      ),
      GlucoseReading(timestamp: day.add(const Duration(hours: 11)), value: 7.8),
    ];
    final events = [
      GlucoseEvent(
        type: GlucoseEventType.highEpisode,
        time: day.add(const Duration(hours: 9)),
        endTime: day.add(const Duration(hours: 10)),
        value: 11.4,
        peakOrNadir: 12.1,
        ratePerMin: 0.12,
      ),
      GlucoseEvent(
        type: GlucoseEventType.recovery,
        time: day.add(const Duration(hours: 11)),
        value: 7.8,
        ratePerMin: -0.08,
      ),
    ];

    final viewModel = const HistoryService().buildViewModel(
      selectedDay: day,
      readings: readings,
      events: events,
      tir: const AnalysisTirResult(
        tir: 50,
        tar: 50,
        tbr: 0,
        tarVeryHigh: 0,
        tbrVeryLow: 0,
        mean: 9.4,
        sd: 1.2,
        cv: 24,
        gmi: 7.3,
        readingCount: 4,
      ),
      isToday: false,
      settings: const AppSettings(),
      l10n: HistoryLocalizationsZh(),
    );

    expect(viewModel.dateNav.dateLabel, '星期六，6月6日');
    expect(viewModel.dateNav.subtitle, '2026 - 日视图');
    expect(viewModel.episodeCallouts.single.label, '高血糖片段');
    expect(viewModel.episodeCallouts.single.summary, contains('持续 60 分钟'));
    expect(viewModel.events.first.detail, contains('高于'));
    expect(viewModel.events.first.valueLabel, contains('峰值'));
    expect(viewModel.events.last.name, '回到目标范围');
  });
}
