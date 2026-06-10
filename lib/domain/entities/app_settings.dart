enum GlucoseUnit { mmolL, mgDl }

class AppSettings {
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final double veryHighThreshold;
  final String? xdripBaseUrl; // e.g. http://127.0.0.1:17580
  final String? xdripApiSecret; // optional SHA1 hash
  final bool xdripSyncEnabled;
  final String? nightscoutBaseUrl;
  final String? nightscoutToken;
  final bool nightscoutSyncEnabled;
  final bool dailyBriefEnabled;
  final bool weeklyReviewEnabled;
  final bool dataHealthCheckEnabled;
  final int retentionDays;
  final int initialSyncDays;

  const AppSettings({
    this.unit = GlucoseUnit.mmolL,
    this.lowThreshold = 3.9,
    this.highThreshold = 10.0,
    this.veryHighThreshold = 13.9,
    this.xdripBaseUrl,
    this.xdripApiSecret,
    this.xdripSyncEnabled = false,
    this.nightscoutBaseUrl,
    this.nightscoutToken,
    this.nightscoutSyncEnabled = false,
    this.dailyBriefEnabled = true,
    this.weeklyReviewEnabled = true,
    this.dataHealthCheckEnabled = true,
    this.retentionDays = 90,
    this.initialSyncDays = 14,
  });

  AppSettings copyWith({
    GlucoseUnit? unit,
    double? lowThreshold,
    double? highThreshold,
    double? veryHighThreshold,
    String? xdripBaseUrl,
    String? xdripApiSecret,
    bool? xdripSyncEnabled,
    String? nightscoutBaseUrl,
    String? nightscoutToken,
    bool? nightscoutSyncEnabled,
    bool clearXdrip = false,
    bool clearNightscout = false,
    bool? dailyBriefEnabled,
    bool? weeklyReviewEnabled,
    bool? dataHealthCheckEnabled,
    int? retentionDays,
    int? initialSyncDays,
  }) => AppSettings(
    unit: unit ?? this.unit,
    lowThreshold: lowThreshold ?? this.lowThreshold,
    highThreshold: highThreshold ?? this.highThreshold,
    veryHighThreshold: veryHighThreshold ?? this.veryHighThreshold,
    xdripBaseUrl: clearXdrip ? null : xdripBaseUrl ?? this.xdripBaseUrl,
    xdripApiSecret: clearXdrip ? null : xdripApiSecret ?? this.xdripApiSecret,
    xdripSyncEnabled:
        clearXdrip ? false : xdripSyncEnabled ?? this.xdripSyncEnabled,
    nightscoutBaseUrl:
        clearNightscout ? null : nightscoutBaseUrl ?? this.nightscoutBaseUrl,
    nightscoutToken:
        clearNightscout ? null : nightscoutToken ?? this.nightscoutToken,
    nightscoutSyncEnabled:
        clearNightscout
            ? false
            : nightscoutSyncEnabled ?? this.nightscoutSyncEnabled,
    dailyBriefEnabled: dailyBriefEnabled ?? this.dailyBriefEnabled,
    weeklyReviewEnabled: weeklyReviewEnabled ?? this.weeklyReviewEnabled,
    dataHealthCheckEnabled:
        dataHealthCheckEnabled ?? this.dataHealthCheckEnabled,
    retentionDays: retentionDays ?? this.retentionDays,
    initialSyncDays: initialSyncDays ?? this.initialSyncDays,
  );
}
