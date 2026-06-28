import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/history/application/history_service.dart';
import 'package:smart_xdrip/plugins/history/domain/history_time_filter.dart';

void main() {
  test('all-day mode keeps all episodes and events', () {
    final day = DateTime(2026, 6, 17);
    final events = _events(day);

    final viewModel = const HistoryService().buildViewModel(
      selectedDay: day,
      readings: _readings(day),
      events: events,
      tir: null,
      isToday: false,
      settings: const AppSettings(),
    );

    expect(viewModel.timeFilter, isNull);
    expect(viewModel.episodeCallouts, hasLength(2));
    expect(viewModel.events, hasLength(events.length));
    expect(
      viewModel.episodeCallouts.map((episode) => episode.title),
      ['Low episode', 'High episode'],
    );
    expect(
      viewModel.episodeCallouts.map((episode) => episode.kind),
      ['low', 'high'],
    );
    expect(
      viewModel.events.map((event) => event.time),
      ['14:00', '08:45', '08:00'],
    );
  });

  test('selected time inside episode filters callouts and nearby events', () {
    final day = DateTime(2026, 6, 17);

    final viewModel = const HistoryService().buildViewModel(
      selectedDay: day,
      readings: _readings(day),
      events: _events(day),
      tir: null,
      isToday: false,
      settings: const AppSettings(),
      timeFilter: HistoryTimeFilter(
          time: day.add(const Duration(hours: 8, minutes: 10))),
    );

    expect(viewModel.timeFilter?.label, 'Focused around 08:10');
    expect(viewModel.episodeCallouts, hasLength(1));
    expect(viewModel.episodeCallouts.single.title, 'High episode');
    expect(viewModel.episodeCallouts.single.meta, contains('40 min'));
    expect(viewModel.events.map((event) => event.time), contains('08:00'));
    expect(
        viewModel.events.map((event) => event.time), isNot(contains('14:00')));
  });

  test('selected time with no nearby event returns focused empty sections', () {
    final day = DateTime(2026, 6, 17);

    final viewModel = const HistoryService().buildViewModel(
      selectedDay: day,
      readings: _readings(day),
      events: _events(day),
      tir: null,
      isToday: false,
      settings: const AppSettings(),
      timeFilter: HistoryTimeFilter(time: day.add(const Duration(hours: 22))),
    );

    expect(viewModel.timeFilter, isNotNull);
    expect(viewModel.episodeCallouts, isEmpty);
    expect(viewModel.events, isEmpty);
  });
}

List<GlucoseReading> _readings(DateTime day) {
  return [
    for (var minute = 0; minute < 24 * 60; minute += 30)
      GlucoseReading(
        timestamp: day.add(Duration(minutes: minute)),
        value: 6.8,
      ),
  ];
}

List<GlucoseEvent> _events(DateTime day) {
  return [
    GlucoseEvent(
      type: GlucoseEventType.highEpisode,
      time: day.add(const Duration(hours: 8)),
      value: 10.8,
      peakOrNadir: 10.8,
      endTime: day.add(const Duration(hours: 8, minutes: 40)),
    ),
    GlucoseEvent(
      type: GlucoseEventType.recovery,
      time: day.add(const Duration(hours: 8, minutes: 45)),
      value: 8.8,
    ),
    GlucoseEvent(
      type: GlucoseEventType.lowEpisode,
      time: day.add(const Duration(hours: 14)),
      value: 3.2,
      peakOrNadir: 3.2,
      endTime: day.add(const Duration(hours: 14, minutes: 25)),
    ),
  ];
}
