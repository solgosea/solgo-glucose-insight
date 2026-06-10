import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/presentation/common/navigation/safe_navigation.dart';
import 'package:provider/provider.dart';

import '../application/settings_actions.dart';
import '../application/settings_export_actions.dart';
import '../application/settings_host_services.dart';
import '../application/settings_storage_actions.dart';
import '../controllers/settings_controller.dart';
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
    if (!_isUninitialized) return;
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
          onPickInitialSyncWindow:
              () => _pickInitialSyncWindow(context, _controller),
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
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Text(
                  'Blood glucose unit',
                  style: TextStyle(
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
                  trailing:
                      option == controller.unitLabel
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

  Future<void> _pickInitialSyncWindow(
    BuildContext context,
    SettingsController controller,
  ) async {
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
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Text(
                  'Initial sync window',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              for (final option in const [7, 14, 30])
                ListTile(
                  onTap: () => Navigator.pop(ctx, option),
                  title: Text(
                    '$option days',
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                  subtitle:
                      option == 14
                          ? const Text(
                            'Recommended balance',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: AppColors.textSoft,
                            ),
                          )
                          : null,
                  trailing:
                      option == controller.settings.initialSyncDays
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
    final messenger = ScaffoldMessenger.of(context);
    final path = await controller.exportReadingsCsv();
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bgCard2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          path == null ? 'No readings to export yet.' : 'Exported to: $path',
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
    final messenger = ScaffoldMessenger.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.bgCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Clear all data?',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            content: const Text(
              'This permanently deletes all stored CGM readings, events, and '
              'analysis snapshots. This cannot be undone.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.textSoft,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSoft),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Delete everything',
                  style: TextStyle(color: AppColors.rose),
                ),
              ),
            ],
          ),
    );
    if (confirm == true) {
      await controller.clearAllData();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.bgCard2,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'All local data cleared.',
            style: TextStyle(
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
