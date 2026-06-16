import 'package:sqflite/sqflite.dart';

import '../../domain/glance_display_mode.dart';
import '../../domain/glance_lock_screen_mode.dart';
import '../../domain/notification_privacy_mode.dart';
import 'glance_tables.dart';

class GlanceNotificationSettings {
  final bool enabled;
  final GlanceNotificationPrivacyMode privacyMode;
  final GlanceLockScreenMode lockScreenMode;
  final bool aodFriendlyEnabled;
  final GlanceDisplayMode notificationDisplayMode;
  final bool externalSurfacesDefaulted;
  final bool quickActionsEnabled;
  final bool lowBatteryMode;

  const GlanceNotificationSettings({
    this.enabled = true,
    this.privacyMode = GlanceNotificationPrivacyMode.full,
    this.lockScreenMode = GlanceLockScreenMode.fullValue,
    this.aodFriendlyEnabled = true,
    this.notificationDisplayMode = GlanceDisplayMode.fullValue,
    this.externalSurfacesDefaulted = false,
    this.quickActionsEnabled = true,
    this.lowBatteryMode = false,
  });

  GlanceNotificationSettings copyWith({
    bool? enabled,
    GlanceNotificationPrivacyMode? privacyMode,
    GlanceLockScreenMode? lockScreenMode,
    bool? aodFriendlyEnabled,
    GlanceDisplayMode? notificationDisplayMode,
    bool? externalSurfacesDefaulted,
    bool? quickActionsEnabled,
    bool? lowBatteryMode,
  }) {
    return GlanceNotificationSettings(
      enabled: enabled ?? this.enabled,
      privacyMode: privacyMode ?? this.privacyMode,
      lockScreenMode: lockScreenMode ?? this.lockScreenMode,
      aodFriendlyEnabled: aodFriendlyEnabled ?? this.aodFriendlyEnabled,
      notificationDisplayMode:
          notificationDisplayMode ?? this.notificationDisplayMode,
      externalSurfacesDefaulted:
          externalSurfacesDefaulted ?? this.externalSurfacesDefaulted,
      quickActionsEnabled: quickActionsEnabled ?? this.quickActionsEnabled,
      lowBatteryMode: lowBatteryMode ?? this.lowBatteryMode,
    );
  }
}

class SqliteGlanceSettingsRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteGlanceSettingsRepository({
    required this.databaseProvider,
  });

  Future<GlanceNotificationSettings> get() async {
    final database = await databaseProvider();
    final rows = await database.query(
      GlanceTables.notificationSettings,
      where: 'id = 1',
      limit: 1,
    );
    if (rows.isEmpty) return const GlanceNotificationSettings();
    final row = rows.first;
    return GlanceNotificationSettings(
      enabled: row['enabled'] == 1,
      privacyMode: GlanceNotificationPrivacyMode.fromCode(
        row['privacy_mode'] as String?,
      ),
      lockScreenMode: GlanceLockScreenMode.fromCode(
        row['lock_screen_mode'] as String?,
      ),
      aodFriendlyEnabled: row['aod_friendly_enabled'] != 0,
      notificationDisplayMode: GlanceDisplayMode.fromCode(
        row['notification_display_mode'] as String?,
      ),
      externalSurfacesDefaulted: row['external_surfaces_defaulted'] == 1,
      quickActionsEnabled: row['quick_actions_enabled'] == 1,
      lowBatteryMode: row['low_battery_mode'] == 1,
    );
  }

  Future<void> save(GlanceNotificationSettings settings) async {
    final database = await databaseProvider();
    await database.insert(
      GlanceTables.notificationSettings,
      {
        'id': 1,
        'enabled': settings.enabled ? 1 : 0,
        'privacy_mode': settings.privacyMode.code,
        'lock_screen_mode': settings.lockScreenMode.code,
        'aod_friendly_enabled': settings.aodFriendlyEnabled ? 1 : 0,
        'notification_display_mode': settings.notificationDisplayMode.code,
        'external_surfaces_defaulted':
            settings.externalSurfacesDefaulted ? 1 : 0,
        'quick_actions_enabled': settings.quickActionsEnabled ? 1 : 0,
        'low_battery_mode': settings.lowBatteryMode ? 1 : 0,
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
