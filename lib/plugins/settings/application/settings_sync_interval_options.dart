class SettingsSyncIntervalOptions {
  static const values = [1, 2, 3, 4, 5];
  static const fallback = 1;

  const SettingsSyncIntervalOptions._();

  static int normalize(int minutes) {
    return values.contains(minutes) ? minutes : fallback;
  }
}
