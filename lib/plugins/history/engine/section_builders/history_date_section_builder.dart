import '../../domain/sections/history_date_section.dart';

class HistoryDateSectionBuilder {
  const HistoryDateSectionBuilder();

  HistoryDateSection build({
    required DateTime selectedDay,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    required bool isToday,
  }) {
    return HistoryDateSection(
      selectedDay: selectedDay,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      isToday: isToday,
    );
  }
}
