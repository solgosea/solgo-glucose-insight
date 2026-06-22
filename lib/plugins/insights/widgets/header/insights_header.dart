import 'package:flutter/material.dart';
import 'package:smart_xdrip/presentation/common/widgets/page_header.dart';

import '../../application/i18n/insights_l10n.dart';

class InsightsHeader extends StatelessWidget {
  final String dateText;
  final VoidCallback onBack;

  const InsightsHeader({
    super.key,
    required this.dateText,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: context.insightsL10n.pluginTitle,
      subtitle: dateText,
      onBack: onBack,
    );
  }
}
