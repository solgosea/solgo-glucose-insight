import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../../../../plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import '../../../../plugin_platform/services/plugin_service_registry.dart';
import '../application/i18n/report_l10n.dart';
import '../controllers/report_controller.dart';
import '../runtime/report_plugin_runtime.dart';
import '../runtime/report_runtime_cache.dart';
import '../widgets/report_body.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ReportController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final existing = _controller;
    if (existing != null) {
      unawaited(existing.updateLocale(context.reportL10n));
      return;
    }
    final services = context.read<PluginServiceRegistry>();
    final runtimeManager = context.read<PluginRuntimeManager>();
    unawaited(
      runtimeManager.resume(ReportPluginRuntime.id),
    );
    _controller = ReportController(
      changeSignal: services.get<Listenable>(),
      runtimeCache: services.get<ReportRuntimeCache>(),
      runtime: services.get<ReportPluginRuntime>(),
      runtimeContext: runtimeManager.context,
    );
    unawaited(_controller!.updateLocale(context.reportL10n));
    _controller!.load();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.green),
        ),
      );
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final viewModel = controller.viewModel;
        if (viewModel == null) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }
        return ReportBody(
          viewModel: viewModel,
          loading: controller.loading,
          exporting: controller.exporting,
          onPeriodChanged: controller.selectPeriod,
          onRefresh: controller.load,
          onToggleSection: controller.toggleSection,
          onExport: controller.export,
        );
      },
    );
  }
}
