import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../application/i18n/history_l10n.dart';

class HistoryPageTitle extends StatelessWidget {
  const HistoryPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Text(
        context.historyL10n.pluginTitle,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}
