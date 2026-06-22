import 'package:flutter/material.dart';

class StatusSetupPromptModel {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String body;
  final String actionLabel;

  const StatusSetupPromptModel({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.body,
    required this.actionLabel,
  });
}
