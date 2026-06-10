import 'package:flutter/material.dart';

import '../banner/alert_banner_action.dart';

class AlertBannerActionRow extends StatelessWidget {
  final List<AlertBannerAction> actions;
  final Color color;
  final ValueChanged<AlertBannerAction> onAction;

  const AlertBannerActionRow({
    super.key,
    required this.actions,
    required this.color,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = actions.where((action) => action.enabled).toList();
    if (enabled.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final action in enabled)
          TextButton(
            onPressed: () => onAction(action),
            style: TextButton.styleFrom(
              foregroundColor: color,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
                side: BorderSide(color: color.withValues(alpha: .35)),
              ),
              backgroundColor: color.withValues(alpha: .10),
            ),
            child: Text(
              action.label,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}
