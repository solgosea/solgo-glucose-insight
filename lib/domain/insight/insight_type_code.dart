enum InsightTypeCode {
  dailyCompleteDay('daily_complete_day'),
  dailyNotEnoughData('daily_not_enough_data'),
  weeklyReview('weekly_review'),
  dawnPattern('dawn_pattern'),
  volatilePeriod('volatile_period'),
  stablePeriod('stable_period'),
  weekdayGap('weekday_gap'),
  calendarBestDay('calendar_best_day'),
  calendarWeekdayWeekend('calendar_weekday_weekend'),
  calendarBestStreak('calendar_best_streak'),
  calendarNoData('calendar_no_data'),
  periodOverview('period_overview'),
  periodWeekdayWeekend('period_weekday_weekend'),
  periodNoData('period_no_data'),
  agpDawnRise('agp_dawn_rise'),
  agpMiddayRecovery('agp_midday_recovery'),
  agpNightStability('agp_night_stability'),
  agpMedianPeak('agp_median_peak'),
  agpVariability('agp_variability'),
  agpNoData('agp_no_data'),
  glucoseEventFirstReading('glucose_event_first_reading'),
  glucoseEventHighEpisode('glucose_event_high_episode'),
  glucoseEventLowEpisode('glucose_event_low_episode'),
  glucoseEventRise('glucose_event_rise'),
  glucoseEventRecovery('glucose_event_recovery'),
  glucoseEventStableWindow('glucose_event_stable_window'),
  glucoseEventDawnPhenomenon('glucose_event_dawn_phenomenon'),
  notEnoughPatternData('not_enough_pattern_data');

  final String code;

  const InsightTypeCode(this.code);

  static InsightTypeCode fromCode(String? code) {
    return InsightTypeCode.values.firstWhere(
      (type) => type.code == code,
      orElse: () => InsightTypeCode.notEnoughPatternData,
    );
  }
}
