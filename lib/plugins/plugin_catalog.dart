import '../plugin_platform/contracts/smart_feature_plugin.dart';
import '../alerting/alerting_plugin.dart';
import 'background/glucose_sync_task_plugin.dart';
import 'background/source_health_task_plugin.dart';
import 'explore/explore_plugin.dart';
import 'history/history_plugin.dart';
import 'home/home_plugin.dart';
import 'profile/profile_plugin.dart';
import 'statistics/statistics_plugin.dart';
import 'explore/high_episode/high_episode_plugin.dart';
import 'explore/low_episode/low_episode_plugin.dart';
import 'home/home_header_widget_plugin.dart';
import 'home/home_hero_widget_plugin.dart';
import 'home/home_insight_widget_plugin.dart';
import 'home/home_range_chart_widget_plugin.dart';
import 'home/home_stats_widget_plugin.dart';
import 'home/home_tir_widget_plugin.dart';
import 'insights/insights_plugin.dart';
import 'profile/data_source_plugin.dart';
import 'profile/target_range_plugin.dart';
import 'settings/sections/settings_about_plugin.dart';
import 'settings/sections/settings_danger_plugin.dart';
import 'settings/sections/settings_display_plugin.dart';
import 'settings/sections/settings_export_plugin.dart';
import 'settings/sections/settings_storage_plugin.dart';
import 'settings/sections/settings_sync_plugin.dart';
import 'settings/settings_plugin.dart';

const pluginCatalog = <SmartFeaturePlugin>[
  HomePlugin(),
  HomeHeaderWidgetPlugin(),
  HomeHeroWidgetPlugin(),
  HomeRangeChartWidgetPlugin(),
  HomeStatsWidgetPlugin(),
  HomeTirWidgetPlugin(),
  HomeInsightWidgetPlugin(),
  HistoryPlugin(),
  StatisticsPlugin(),
  ExplorePlugin(),
  ProfilePlugin(),
  AlertingPlugin(),
  DataSourcePlugin(),
  TargetRangePlugin(),
  SettingsPlugin(),
  SettingsDisplayPlugin(),
  SettingsSyncPlugin(),
  SettingsStoragePlugin(),
  SettingsExportPlugin(),
  SettingsDangerPlugin(),
  SettingsAboutPlugin(),
  SourceHealthTaskPlugin(),
  GlucoseSyncTaskPlugin(),
  InsightsPlugin(),
  HighEpisodePlugin(),
  LowEpisodePlugin(),
];
