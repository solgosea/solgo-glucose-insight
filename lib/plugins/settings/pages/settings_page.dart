import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/i18n/app_locale_controller.dart';
import 'package:smart_xdrip/application/i18n/app_locale_option.dart';
import 'package:smart_xdrip/application/i18n/app_localization_context.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/presentation/common/navigation/safe_navigation.dart';
import 'package:provider/provider.dart';

import '../application/settings_actions.dart';
import '../application/settings_export_actions.dart';
import '../application/settings_host_services.dart';
import '../application/settings_sync_window_options.dart';
import '../application/i18n/settings_l10n.dart';
import '../application/settings_storage_actions.dart';
import '../controllers/settings_controller.dart';
import '../mappers/settings_view_model_mapper.dart';
import '../runtime/settings_plugin_runtime.dart';
import '../runtime/settings_runtime_cache.dart';
import '../widgets/settings_body.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsController _controller;
  bool _isUninitialized = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settingsL10n = context.settingsL10n;
    if (!_isUninitialized) {
      _controller.useMapper(SettingsViewModelMapper(l10n: settingsL10n));
      return;
    }
    _isUninitialized = false;
    final services = context.read<PluginServiceRegistry>();
    final runtimeManager = context.read<PluginRuntimeManager>();
    unawaited(runtimeManager.resume(SettingsPluginRuntime.id));
    _controller = SettingsController(
      hostServices: services.get<SettingsHostServices>(),
      settingsActions: services.get<SettingsActions>(),
      storageActions: services.get<SettingsStorageActions>(),
      exportActions: services.get<SettingsExportActions>(),
      runtimeCache: services.get<SettingsRuntimeCache>(),
      runtime: services.get<SettingsPluginRuntime>(),
      mapper: SettingsViewModelMapper(l10n: settingsL10n),
    );
    unawaited(_controller.load());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final viewModel = _controller.viewModel;
        if (viewModel == null) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }

        return SettingsBody(
          viewModel: viewModel,
          onBack: () => context.safePopOrHome(),
          onPickUnit: () => _pickUnit(context, _controller),
          onPickLanguage: () => _pickLanguage(context),
          onPickInitialSyncWindow: () =>
              _pickInitialSyncWindow(context, _controller),
          onExportCsv: () => _exportCsv(context, _controller),
          onClearAllData: () => _confirmClear(context, _controller),
        );
      },
    );
  }

  Future<void> _pickUnit(
    BuildContext context,
    SettingsController controller,
  ) async {
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Text(
                  l10n.settingsBloodGlucoseUnit,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              for (final option in const ['mmol/L', 'mg/dL'])
                ListTile(
                  onTap: () => Navigator.pop(ctx, option),
                  title: Text(
                    option,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                  trailing: option == controller.unitLabel
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.green,
                          size: 18,
                        )
                      : null,
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != controller.unitLabel) {
      await controller.setUnitLabel(selected);
    }
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final controller = context.read<AppLocaleController>();
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final selected = await showModalBottomSheet<AppLocaleOption>(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final current = controller.locale;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Text(
                  l10n.settingsLanguageTitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              _LanguageOptionTile(
                label: l10n.settingsLanguageSystem,
                selected: current == null,
                option: AppLocaleOption.system,
              ),
              _LanguageOptionTile(
                label: l10n.settingsLanguageEnglish,
                selected: current?.languageCode == 'en',
                option: AppLocaleOption.english,
              ),
              _LanguageOptionTile(
                label: l10n.settingsLanguageSimplifiedChinese,
                selected: current?.languageCode == 'zh' &&
                    current?.scriptCode != 'Hant',
                option: AppLocaleOption.simplifiedChinese,
              ),
              _LanguageOptionTile(
                label: l10n.settingsLanguageTraditionalChinese,
                selected: current?.languageCode == 'zh' &&
                    current?.scriptCode == 'Hant',
                option: AppLocaleOption.traditionalChinese,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected == null) return;
    final locale = selected.locale;
    if (locale == null) {
      await controller.useSystemLocale();
    } else {
      await controller.setLocale(locale);
    }
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bgCard2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          l10n.settingsLanguageChanged,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: AppColors.textSoft,
          ),
        ),
      ),
    );
  }

  Future<void> _pickInitialSyncWindow(
    BuildContext context,
    SettingsController controller,
  ) async {
    final l10n = context.settingsL10n;
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Text(
                  l10n.settingsInitialSyncWindowLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              for (final option in SettingsSyncWindowOptions.values)
                ListTile(
                  onTap: () => Navigator.pop(ctx, option),
                  title: Text(
                    '$option ${l10n.settingsDaysSuffix}',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                  subtitle: option == SettingsSyncWindowOptions.recommended
                      ? Text(
                          l10n.settingsRecommendedBalance,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: AppColors.textSoft,
                          ),
                        )
                      : null,
                  trailing: option == controller.settings.initialSyncDays
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.green,
                          size: 18,
                        )
                      : null,
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected != null && selected != controller.settings.initialSyncDays) {
      await controller.setInitialSyncDays(selected);
    }
  }

  Future<void> _exportCsv(
    BuildContext context,
    SettingsController controller,
  ) async {
    final l10n = context.settingsL10n;
    final messenger = ScaffoldMessenger.of(context);
    final path = await controller.exportReadingsCsv();
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bgCard2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          path == null
              ? l10n.settingsExportNoReadings
              : '${l10n.settingsExportedTo} $path',
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: AppColors.textSoft,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    SettingsController controller,
  ) async {
    final l10n = context.settingsL10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.settingsClearAllDataDialogTitle,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        content: Text(
          l10n.settingsClearAllDataDialogBody,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.textSoft,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l10n.settingsCancel,
              style: const TextStyle(color: AppColors.textSoft),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.settingsDeleteEverything,
              style: const TextStyle(color: AppColors.rose),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await controller.clearAllData();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.bgCard2,
          behavior: SnackBarBehavior.floating,
          content: Text(
            l10n.settingsAllLocalDataCleared,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              color: AppColors.textSoft,
            ),
          ),
        ),
      );
    }
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final AppLocaleOption option;

  const _LanguageOptionTile({
    required this.label,
    required this.selected,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pop(context, option),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.green : AppColors.text,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_rounded,
              color: AppColors.green,
              size: 18,
            )
          : null,
    );
  }
}
