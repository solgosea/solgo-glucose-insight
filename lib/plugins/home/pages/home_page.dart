import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import '../application/i18n/home_l10n.dart';
import '../application/home_host_services.dart';
import '../controllers/home_controller.dart';
import '../runtime/home_plugin_runtime.dart';
import '../runtime/home_runtime_cache.dart';
import '../widgets/home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      _controller.updateLocale(context.homeL10n);
      return;
    }
    _initialized = true;
    final services = context.read<PluginServiceRegistry>();
    unawaited(
      context.read<PluginRuntimeManager>().resume(HomePluginRuntime.id),
    );
    _controller = HomeController(
      hostServices: services.get<HomeHostServices>(),
      runtimeCache: services.get<HomeRuntimeCache>(),
      runtime: services.get<HomePluginRuntime>(),
    );
    _controller.updateLocale(context.homeL10n);
    _controller.init();
  }

  bool _initialized = false;

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
          return HomeBody(
            viewModel: viewModel,
            onRangeChanged: _controller.selectRange,
            onUnitChanged: _controller.updateUnit,
            onInsightTap: () => context.push('/insights'),
            onSwitchBackToSelf: _controller.switchBackToSelf,
          );
        },
      ),
    );
  }
}
