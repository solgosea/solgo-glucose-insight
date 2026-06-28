class StatusHubMetricThresholds {
  static const Duration freshAgeExcellent = Duration(minutes: 6);
  static const Duration freshAgeGood = Duration(minutes: 10);
  static const Duration freshAgeWatch = Duration(minutes: 15);
  static const Duration freshAgeDegraded = Duration(minutes: 30);

  static const Duration delayExcellent = Duration(minutes: 3);
  static const Duration delayGood = Duration(minutes: 8);
  static const Duration delayWatch = Duration(minutes: 15);
  static const Duration delayDegraded = Duration(minutes: 30);

  static const int responseExcellentMs = 800;
  static const int responseGoodMs = 2000;
  static const int responseWatchMs = 5000;
}
