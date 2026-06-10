import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/app_settings.dart';

/// Settings persistence:
/// - Non-secret values (unit, thresholds, notification toggles) -> SharedPreferences
/// - Secrets (xDrip API secret, Nightscout token) -> flutter_secure_storage
class SettingsStore {
  static const _kUnit = 'unit';
  static const _kLow = 'low_threshold';
  static const _kHigh = 'high_threshold';
  static const _kVeryHigh = 'very_high_threshold';
  static const _kXdripUrl = 'xdrip_base_url';
  static const _kXdripSyncEnabled = 'xdrip_sync_enabled';
  static const _kNsUrl = 'nightscout_base_url';
  static const _kNsSyncEnabled = 'nightscout_sync_enabled';
  static const _kDailyBrief = 'daily_brief_enabled';
  static const _kWeekly = 'weekly_review_enabled';
  static const _kHealth = 'data_health_enabled';
  static const _kRetention = 'retention_days';
  static const _kInitialSyncDays = 'initial_sync_days';

  static const _secXdripSecret = 'sec_xdrip_api_secret';
  static const _secNsToken = 'sec_nightscout_token';

  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  Future<AppSettings> load() async {
    final sp = await SharedPreferences.getInstance();
    return AppSettings(
      unit: GlucoseUnit.values[sp.getInt(_kUnit) ?? 0],
      lowThreshold: sp.getDouble(_kLow) ?? 3.9,
      highThreshold: sp.getDouble(_kHigh) ?? 10.0,
      veryHighThreshold: sp.getDouble(_kVeryHigh) ?? 13.9,
      xdripBaseUrl: sp.getString(_kXdripUrl),
      xdripApiSecret: await _secure.read(key: _secXdripSecret),
      xdripSyncEnabled: sp.getBool(_kXdripSyncEnabled) ?? false,
      nightscoutBaseUrl: sp.getString(_kNsUrl),
      nightscoutToken: await _secure.read(key: _secNsToken),
      nightscoutSyncEnabled: sp.getBool(_kNsSyncEnabled) ?? false,
      dailyBriefEnabled: sp.getBool(_kDailyBrief) ?? true,
      weeklyReviewEnabled: sp.getBool(_kWeekly) ?? true,
      dataHealthCheckEnabled: sp.getBool(_kHealth) ?? true,
      retentionDays: sp.getInt(_kRetention) ?? 90,
      initialSyncDays: sp.getInt(_kInitialSyncDays) ?? 14,
    );
  }

  Future<void> save(AppSettings s) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kUnit, s.unit.index);
    await sp.setDouble(_kLow, s.lowThreshold);
    await sp.setDouble(_kHigh, s.highThreshold);
    await sp.setDouble(_kVeryHigh, s.veryHighThreshold);
    await _setOrRemoveString(sp, _kXdripUrl, s.xdripBaseUrl);
    await _setOrRemoveString(sp, _kNsUrl, s.nightscoutBaseUrl);
    await sp.setBool(_kXdripSyncEnabled, s.xdripSyncEnabled);
    await sp.setBool(_kNsSyncEnabled, s.nightscoutSyncEnabled);
    await sp.setBool(_kDailyBrief, s.dailyBriefEnabled);
    await sp.setBool(_kWeekly, s.weeklyReviewEnabled);
    await sp.setBool(_kHealth, s.dataHealthCheckEnabled);
    await sp.setInt(_kRetention, s.retentionDays);
    await sp.setInt(_kInitialSyncDays, s.initialSyncDays);
    await _setOrRemoveSecret(_secXdripSecret, s.xdripApiSecret);
    await _setOrRemoveSecret(_secNsToken, s.nightscoutToken);
  }

  Future<void> _setOrRemoveString(
    SharedPreferences sp,
    String k,
    String? v,
  ) async {
    if (v == null || v.isEmpty) {
      await sp.remove(k);
    } else {
      await sp.setString(k, v);
    }
  }

  Future<void> _setOrRemoveSecret(String k, String? v) async {
    if (v == null || v.isEmpty) {
      await _secure.delete(key: k);
    } else {
      await _secure.write(key: k, value: v);
    }
  }
}
