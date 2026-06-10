import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../episode_detail/controllers/episode_detail_controller.dart';
import '../../episode_detail/models/episode_kind.dart';
import '../../episode_detail/runtime/episode_detail_plugin_runtime.dart';
import '../../episode_detail/runtime/episode_detail_runtime_cache.dart';
import '../../episode_detail/widgets/episode_detail_body.dart';

class HighEpisodePage extends StatefulWidget {
  const HighEpisodePage({super.key});

  @override
  State<HighEpisodePage> createState() => _HighEpisodePageState();
}

class _HighEpisodePageState extends State<HighEpisodePage> {
  EpisodeDetailController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final runtimeManager = context.read<PluginRuntimeManager>();
    final services = context.read<PluginServiceRegistry>();
    runtimeManager.resume(EpisodeDetailPluginRuntime.id);
    _controller = EpisodeDetailController(
      kind: EpisodeKind.high,
      runtimeCache: services.get<EpisodeDetailRuntimeCache>(),
      runtime: services.get<EpisodeDetailPluginRuntime>(),
      runtimeContext: runtimeManager.context,
    );
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
        body: Center(child: CircularProgressIndicator(color: AppColors.rose)),
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
              child: CircularProgressIndicator(color: AppColors.rose),
            ),
          );
        }
        return EpisodeDetailBody(viewModel: viewModel);
      },
    );
  }
}
