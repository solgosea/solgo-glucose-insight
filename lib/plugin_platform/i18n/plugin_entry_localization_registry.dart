import 'package:flutter/widgets.dart';

import '../contracts/plugin_entry.dart';
import '../contracts/plugin_id.dart';
import 'plugin_entry_localizer.dart';

class PluginEntryLocalizationRegistry {
  final Map<String, PluginEntryLocalizer> _localizers = {};

  void register(PluginId pluginId, PluginEntryLocalizer localizer) {
    _localizers[pluginId.value] = localizer;
  }

  MainTabPluginEntry localizeMainTab(
    MainTabPluginEntry entry,
    Locale locale,
  ) {
    return _localizers[entry.pluginId]?.localizeMainTab(entry, locale) ??
        entry;
  }

  ExplorePluginEntry localizeExplore(
    ExplorePluginEntry entry,
    Locale locale,
  ) {
    return _localizers[entry.pluginId]?.localizeExplore(entry, locale) ??
        entry;
  }

  SectionPluginEntry localizeSection(
    SectionPluginEntry entry,
    Locale locale,
  ) {
    return _localizers[entry.pluginId]?.localizeSection(entry, locale) ??
        entry;
  }

  HomeWidgetPluginEntry localizeHomeWidget(
    HomeWidgetPluginEntry entry,
    Locale locale,
  ) {
    return _localizers[entry.pluginId]?.localizeHomeWidget(entry, locale) ??
        entry;
  }

  BackgroundTaskPluginEntry localizeBackgroundTask(
    BackgroundTaskPluginEntry entry,
    Locale locale,
  ) {
    return _localizers[entry.pluginId]
            ?.localizeBackgroundTask(entry, locale) ??
        entry;
  }
}
