import 'package:flutter/material.dart';

import '../../theme/status_probe_ui_theme.dart';

class StatusProbeIconBadge extends StatelessWidget {
  final String tone;
  final IconData icon;
  final String? text;
  final double size;

  const StatusProbeIconBadge({
    super.key,
    required this.tone,
    required this.icon,
    this.text,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    final color = StatusProbeUiTheme.toneColor(tone);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withOpacity(.34)),
      ),
      child: text == null
          ? Icon(icon, size: size * .48, color: color)
          : Text(
              text!,
              style: StatusProbeUiTheme.mono(
                context,
                size: size * .25,
                weight: FontWeight.w900,
                color: color,
              ),
            ),
    );
  }
}
