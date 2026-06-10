import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/presentation/common/navigation/safe_navigation.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import '../application/insights_host_services.dart';
import '../controllers/insights_controller.dart';
import '../runtime/insights_plugin_runtime.dart';
import '../runtime/insights_runtime_cache.dart';
import '../widgets/insights_body.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late final InsightsController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final services = context.read<PluginServiceRegistry>();
    final runtimeManager = context.read<PluginRuntimeManager>();
    unawaited(runtimeManager.resume(InsightsPluginRuntime.id));
    _controller = InsightsController(
      hostServices: services.get<InsightsHostServices>(),
      runtimeCache: services.get<InsightsRuntimeCache>(),
      runtime: services.get<InsightsPluginRuntime>(),
    );
    unawaited(_controller.init());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final viewModel = _controller.viewModel;
          if (viewModel == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.green),
            );
          }
          return InsightsBody(
            viewModel: viewModel,
            onBack: () => context.safePopOrHome(),
          );
        },
      ),
    );
  }
}
