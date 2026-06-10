import 'package:flutter/material.dart';

class MainTabPluginEntry {
  final String label;
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final int order;

  const MainTabPluginEntry({
    required this.label,
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.order,
  });
}

class ExplorePluginEntry {
  final String section;
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final Color? accentColor;
  final int order;

  const ExplorePluginEntry({
    required this.section,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.icon,
    this.accentColor,
    required this.order,
  });
}

class SectionPluginEntry {
  final String section;
  final String title;
  final String subtitle;
  final int order;

  const SectionPluginEntry({
    required this.section,
    required this.title,
    required this.subtitle,
    required this.order,
  });
}

class HomeWidgetPluginEntry {
  final String widgetKey;
  final String title;
  final String description;
  final int order;

  const HomeWidgetPluginEntry({
    required this.widgetKey,
    required this.title,
    required this.description,
    required this.order,
  });
}

class BackgroundTaskPluginEntry {
  final String taskKey;
  final String title;
  final String description;
  final Duration interval;
  final bool foregroundService;
  final int order;

  const BackgroundTaskPluginEntry({
    required this.taskKey,
    required this.title,
    required this.description,
    required this.interval,
    required this.foregroundService,
    required this.order,
  });
}
