import 'package:flutter/material.dart';

import '../widgets/setup_prompt/status_setup_prompt_model.dart';
import 'status_view_models.dart';

class StatusDashboardNotice {
  final IconData icon;
  final Color accentColor;
  final String title;
  final String body;

  const StatusDashboardNotice({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.body,
  });
}

class StatusDashboardState {
  final StatusDashboardViewModel viewModel;
  final StatusSetupPromptModel? setupPrompt;
  final StatusDashboardNotice? notice;
  final bool refreshing;

  const StatusDashboardState({
    required this.viewModel,
    this.setupPrompt,
    this.notice,
    this.refreshing = false,
  });
}
