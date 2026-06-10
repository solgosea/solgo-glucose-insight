import '../../domain/entities/app_settings.dart';

class AppSettingsChange {
  final AppSettings previous;
  final AppSettings next;

  const AppSettingsChange({required this.previous, required this.next});

  bool get unitChanged => previous.unit != next.unit;

  bool get thresholdChanged =>
      previous.lowThreshold != next.lowThreshold ||
      previous.highThreshold != next.highThreshold ||
      previous.veryHighThreshold != next.veryHighThreshold;

  bool get syncStrategyChanged =>
      previous.xdripSyncEnabled != next.xdripSyncEnabled ||
      previous.nightscoutSyncEnabled != next.nightscoutSyncEnabled;

  bool get dataSourceConfigChanged =>
      syncStrategyChanged ||
      previous.xdripBaseUrl != next.xdripBaseUrl ||
      previous.xdripApiSecret != next.xdripApiSecret ||
      previous.nightscoutBaseUrl != next.nightscoutBaseUrl ||
      previous.nightscoutToken != next.nightscoutToken;

  bool get syncPolicyChanged =>
      previous.initialSyncDays != next.initialSyncDays ||
      previous.retentionDays != next.retentionDays;

  bool get insightPreferenceChanged =>
      previous.dailyBriefEnabled != next.dailyBriefEnabled ||
      previous.weeklyReviewEnabled != next.weeklyReviewEnabled ||
      previous.dataHealthCheckEnabled != next.dataHealthCheckEnabled;

  bool get anyChanged =>
      unitChanged ||
      thresholdChanged ||
      dataSourceConfigChanged ||
      syncPolicyChanged ||
      insightPreferenceChanged;
}
