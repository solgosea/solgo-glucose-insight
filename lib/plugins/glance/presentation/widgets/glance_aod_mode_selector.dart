import 'package:flutter/material.dart';

import '../styles/glance_theme.dart';

class GlanceAodModeSelector extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const GlanceAodModeSelector({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Works through Android notification behavior where supported.',
            style: GlanceTheme.label.copyWith(
              color: GlanceTheme.soft,
              fontSize: 11.5,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: enabled,
          activeColor: GlanceTheme.green,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
