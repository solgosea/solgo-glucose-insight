enum InsightSlotCode {
  dailyBrief('daily_brief'),
  weeklyReview('weekly_review'),
  patternCard('pattern_card'),
  calendarSummary('calendar_summary'),
  calendarPattern('calendar_pattern'),
  calendarEmptyState('calendar_empty_state'),
  periodSummary('period_summary'),
  periodPattern('period_pattern'),
  periodEmptyState('period_empty_state'),
  agpObservation('agp_observation'),
  agpEmptyState('agp_empty_state'),
  glucoseEventsCountSummary('glucose_events_count_summary'),
  glucoseEventsShortcutEmpty('glucose_events_shortcut_empty'),
  glucoseEventsEmptyState('glucose_events_empty_state'),
  glucoseEventRow('glucose_event_row'),
  emptyState('empty_state');

  final String code;

  const InsightSlotCode(this.code);

  static InsightSlotCode fromCode(String? code) {
    return InsightSlotCode.values.firstWhere(
      (slot) => slot.code == code,
      orElse: () => InsightSlotCode.patternCard,
    );
  }
}
