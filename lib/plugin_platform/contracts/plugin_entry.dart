import 'package:flutter/material.dart';

class MainTabPluginEntry {
  final String pluginId;
  final String label;
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final int order;

  const MainTabPluginEntry({
    this.pluginId = '',
    required this.label,
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.order,
  });

  MainTabPluginEntry copyWith({
    String? pluginId,
    String? label,
    String? route,
    IconData? icon,
    IconData? activeIcon,
    int? order,
  }) {
    return MainTabPluginEntry(
      pluginId: pluginId ?? this.pluginId,
      label: label ?? this.label,
      route: route ?? this.route,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      order: order ?? this.order,
    );
  }
}

class ExplorePluginEntry {
  final String pluginId;
  final String section;
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color? accentColor;
  final int order;

  const ExplorePluginEntry({
    this.pluginId = '',
    required this.section,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    this.accentColor,
    required this.order,
  });

  ExplorePluginEntry copyWith({
    String? pluginId,
    String? section,
    String? title,
    String? subtitle,
    String? route,
    IconData? icon,
    Color? accentColor,
    int? order,
  }) {
    return ExplorePluginEntry(
      pluginId: pluginId ?? this.pluginId,
      section: section ?? this.section,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      route: route ?? this.route,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
      order: order ?? this.order,
    );
  }
}

class SectionPluginEntry {
  final String pluginId;
  final String section;
  final String title;
  final String subtitle;
  final int order;

  const SectionPluginEntry({
    this.pluginId = '',
    required this.section,
    required this.title,
    required this.subtitle,
    required this.order,
  });

  SectionPluginEntry copyWith({
    String? pluginId,
    String? section,
    String? title,
    String? subtitle,
    int? order,
  }) {
    return SectionPluginEntry(
      pluginId: pluginId ?? this.pluginId,
      section: section ?? this.section,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      order: order ?? this.order,
    );
  }
}

class HomeWidgetPluginEntry {
  final String pluginId;
  final String widgetKey;
  final String title;
  final String description;
  final int order;

  const HomeWidgetPluginEntry({
    this.pluginId = '',
    required this.widgetKey,
    required this.title,
    required this.description,
    required this.order,
  });

  HomeWidgetPluginEntry copyWith({
    String? pluginId,
    String? widgetKey,
    String? title,
    String? description,
    int? order,
  }) {
    return HomeWidgetPluginEntry(
      pluginId: pluginId ?? this.pluginId,
      widgetKey: widgetKey ?? this.widgetKey,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
    );
  }
}

class BackgroundTaskPluginEntry {
  final String pluginId;
  final String taskKey;
  final String title;
  final String description;
  final Duration interval;
  final bool foregroundService;
  final int order;

  const BackgroundTaskPluginEntry({
    this.pluginId = '',
    required this.taskKey,
    required this.title,
    required this.description,
    required this.interval,
    required this.foregroundService,
    required this.order,
  });

  BackgroundTaskPluginEntry copyWith({
    String? pluginId,
    String? taskKey,
    String? title,
    String? description,
    Duration? interval,
    bool? foregroundService,
    int? order,
  }) {
    return BackgroundTaskPluginEntry(
      pluginId: pluginId ?? this.pluginId,
      taskKey: taskKey ?? this.taskKey,
      title: title ?? this.title,
      description: description ?? this.description,
      interval: interval ?? this.interval,
      foregroundService: foregroundService ?? this.foregroundService,
      order: order ?? this.order,
    );
  }
}
