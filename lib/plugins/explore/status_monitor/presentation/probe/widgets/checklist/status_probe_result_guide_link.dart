import 'package:flutter/material.dart';

import '../../../styles/status_monitor_theme.dart';
import '../../theme/status_probe_ui_theme.dart';

class StatusProbeResultGuideLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const StatusProbeResultGuideLink({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 30),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: StatusMonitorTheme.amber.withOpacity(.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: StatusMonitorTheme.amber.withOpacity(.34)),
        ),
        child: Text(
          label,
          style: StatusProbeUiTheme.mono(
            context,
            size: 10,
            weight: FontWeight.w900,
            color: StatusMonitorTheme.amber,
          ).copyWith(letterSpacing: .2),
        ),
      ),
    );
  }
}
