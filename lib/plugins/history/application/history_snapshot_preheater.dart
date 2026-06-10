import '../mappers/history_view_model_mapper.dart';
import '../runtime/history_runtime_cache.dart';
import 'history_day_query.dart';
import 'history_host_services.dart';

class HistorySnapshotPreheater {
  final HistoryHostServices hostServices;
  final HistoryViewModelMapper mapper;
  final DateTime Function() now;

  const HistorySnapshotPreheater({
    required this.hostServices,
    this.mapper = const HistoryViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<HistoryRuntimeSnapshot> preheat({required DateTime day}) async {
    final facade = hostServices.facadeProvider();
    final selectedDay = DateTime(day.year, day.month, day.day);
    final readings = facade.readingsForDay(selectedDay);
    final tir = readings.isNotEmpty ? facade.tirForReadings(readings) : null;
    final facadeEvents = facade.eventsForDay(selectedDay);
    final events =
        facadeEvents.isNotEmpty
            ? facadeEvents
            : facade.detectEventsForReadings(readings);
    final query = HistoryDayQuery(
      subjectId: facade.activeSubject.id,
      day: selectedDay,
    );

    return HistoryRuntimeSnapshot(
      query: query,
      viewModel: mapper.map(
        selectedDay: selectedDay,
        readings: readings,
        events: events,
        tir: tir,
        isToday: _isToday(selectedDay),
        settings: hostServices.settingsProvider(),
      ),
      updatedAt: now(),
    );
  }

  bool _isToday(DateTime day) {
    final current = now();
    return day.year == current.year &&
        day.month == current.month &&
        day.day == current.day;
  }
}
