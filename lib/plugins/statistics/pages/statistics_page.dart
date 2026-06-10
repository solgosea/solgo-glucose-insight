import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import '../application/statistics_host_services.dart';
import '../controllers/statistics_controller.dart';
import '../runtime/statistics_plugin_runtime.dart';
import '../runtime/statistics_runtime_cache.dart';
import '../widgets/statistics_body.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late final StatisticsController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final services = context.read<PluginServiceRegistry>();
    final runtimeManager = context.read<PluginRuntimeManager>();
    unawaited(runtimeManager.resume(StatisticsPluginRuntime.id));
    _controller = StatisticsController(
      hostServices: services.get<StatisticsHostServices>(),
      runtimeCache: services.get<StatisticsRuntimeCache>(),
      runtime: services.get<StatisticsPluginRuntime>(),
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
          return StatisticsBody(
            viewModel: viewModel,
            onPeriodChanged: _controller.selectPeriod,
          );
        },
      ),
    );
  }
}
