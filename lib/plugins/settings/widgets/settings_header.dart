import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/i18n/app_localization_context.dart';
import 'package:smart_xdrip/presentation/common/widgets/page_header.dart';

class SettingsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: context.l10n.settingsTitle,
      onBack: onBack,
    );
  }
}
