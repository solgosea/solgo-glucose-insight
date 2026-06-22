enum DayPeriod {
  dawn,
  morning,
  afternoon,
  evening,
  night;

  static DayPeriod fromHour(int hour) {
    if (hour >= 5 && hour < 8) return DayPeriod.dawn;
    if (hour >= 8 && hour < 12) return DayPeriod.morning;
    if (hour >= 12 && hour < 18) return DayPeriod.afternoon;
    if (hour >= 18 && hour < 22) return DayPeriod.evening;
    return DayPeriod.night;
  }
}
