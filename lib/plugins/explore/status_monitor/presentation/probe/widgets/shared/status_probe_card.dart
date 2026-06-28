import 'package:flutter/material.dart';

import '../../theme/status_probe_ui_theme.dart';

class StatusProbeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const StatusProbeCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin = const EdgeInsets.fromLTRB(20, 0, 20, 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: StatusProbeUiTheme.probeCard(),
      child: child,
    );
  }
}
