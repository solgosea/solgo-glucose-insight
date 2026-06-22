import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/application/i18n/app_locale_controller.dart';
import 'package:smart_xdrip/application/i18n/app_localization_context.dart';

import '../models/settings_view_model.dart';
import 'settings_group.dart';
import 'settings_row.dart';

class SettingsDisplayGroup extends StatelessWidget {
  final SettingsDisplayViewModel viewModel;
  final VoidCallback onPickUnit;
  final VoidCallback onPickLanguage;

  const SettingsDisplayGroup({
    super.key,
    required this.viewModel,
    required this.onPickUnit,
    required this.onPickLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.watch<AppLocaleController>().locale;
    return SettingsGroup(
      children: [
        SettingsRow(
          row: SettingsRowViewModel(
            icon: Icons.language_rounded,
            label: l10n.settingsLanguageTitle,
            subtitle: l10n.settingsLanguageDescription,
            valueLabel: _languageLabel(context, locale),
            chevron: true,
            action: SettingsAction.pickLanguage,
          ),
          onTap: onPickLanguage,
        ),
        SettingsRow(
          row: viewModel.unitRow,
          onTap: onPickUnit,
        ),
      ],
    );
  }

  String _languageLabel(BuildContext context, Locale? locale) {
    final l10n = context.l10n;
    if (locale == null) return l10n.settingsLanguageSystem;
    if (locale.languageCode == 'zh' && locale.scriptCode == 'Hant') {
      return l10n.settingsLanguageTraditionalChinese;
    }
    if (locale.languageCode == 'zh') {
      return l10n.settingsLanguageSimplifiedChinese;
    }
    return l10n.settingsLanguageEnglish;
  }
}
