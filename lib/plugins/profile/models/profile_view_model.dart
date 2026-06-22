import 'package:flutter/material.dart';

class ProfileViewModel {
  final ProfileHeaderViewModel header;
  final List<ProfileStatViewModel> stats;
  final String appSettingsSummary;

  const ProfileViewModel({
    required this.header,
    required this.stats,
    required this.appSettingsSummary,
  });
}

class ProfileHeaderViewModel {
  final String title;
  final String primaryBadge;

  const ProfileHeaderViewModel({
    required this.title,
    required this.primaryBadge,
  });
}

class ProfileStatViewModel {
  final String value;
  final String? unit;
  final String label;
  final Color valueColor;

  const ProfileStatViewModel({
    required this.value,
    this.unit,
    required this.label,
    required this.valueColor,
  });
}
