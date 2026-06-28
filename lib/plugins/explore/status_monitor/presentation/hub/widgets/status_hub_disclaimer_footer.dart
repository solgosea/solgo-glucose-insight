import 'package:flutter/material.dart';

import '../models/status_hub_view_model.dart';
import '../../styles/status_monitor_theme.dart';

class StatusHubDisclaimerFooter extends StatelessWidget {
  final StatusHubViewModel viewModel;

  const StatusHubDisclaimerFooter({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Text(
        viewModel.disclaimer,
        textAlign: TextAlign.center,
        style: StatusMonitorTheme.inter.copyWith(
          color: StatusMonitorTheme.dim,
          fontSize: 10.5,
          height: 1.35,
        ),
      ),
    );
  }
}
