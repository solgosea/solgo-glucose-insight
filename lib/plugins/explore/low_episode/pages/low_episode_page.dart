import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../episode_detail/controllers/episode_detail_controller.dart';
import '../../episode_detail/application/episode_detail_route_codec.dart';
import '../../episode_detail/application/i18n/episode_detail_l10n.dart';
import '../../episode_detail/domain/episode_detail_entry_intent.dart';
import '../../episode_detail/mappers/episode_detail_view_model_mapper.dart';
import '../../episode_detail/models/episode_kind.dart';
import '../../episode_detail/runtime/episode_detail_plugin_runtime.dart';
import '../../episode_detail/runtime/episode_detail_runtime_cache.dart';
import '../../episode_detail/widgets/episode_detail_body.dart';

class LowEpisodePage extends StatefulWidget {
  const LowEpisodePage({super.key});

  @override
  State<LowEpisodePage> createState() => _LowEpisodePageState();
}

class _LowEpisodePageState extends State<LowEpisodePage> {
  EpisodeDetailController? _controller;
  final EpisodeDetailRouteCodec _routeCodec = const EpisodeDetailRouteCodec();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final existing = _controller;
    if (existing != null) {
      existing.remapWith(
        EpisodeDetailViewModelMapper(l10n: context.episodeDetailL10n),
      );
      return;
    }
    final intent = _routeCodec.decode(
      GoRouterState.of(context).uri,
      kind: EpisodeKind.low,
    );
    _controller = _createController(intent);
    _controller!.load();
  }

  EpisodeDetailController _createController(EpisodeDetailEntryIntent intent) {
    final runtimeManager = context.read<PluginRuntimeManager>();
    final services = context.read<PluginServiceRegistry>();
    runtimeManager.resume(EpisodeDetailPluginRuntime.id);
    return EpisodeDetailController(
      intent: intent,
      runtimeCache: services.get<EpisodeDetailRuntimeCache>(),
      runtime: services.get<EpisodeDetailPluginRuntime>(),
      runtimeContext: runtimeManager.context,
      mapper: EpisodeDetailViewModelMapper(l10n: context.episodeDetailL10n),
    );
  }

  void _resetToLatest() {
    final latest = const EpisodeDetailEntryIntent.latest(
      kind: EpisodeKind.low,
    );
    final next = _createController(latest);
    final previous = _controller;
    setState(() => _controller = next);
    previous?.dispose();
    context.go(_routeCodec.encode(latest));
    next.load();
  }

  void _openReportPreview() {
    final controller = _controller;
    if (controller == null) return;
    final encoded = Uri.parse(_routeCodec.encode(controller.intent));
    final previewUri = encoded.replace(
      path: '/explore/low-episode/report-preview',
    );
    context.push(previewUri.toString());
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
          child: CircularProgressIndicator(color: AppColors.blue),
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
              child: CircularProgressIndicator(color: AppColors.blue),
            ),
          );
        }
        return EpisodeDetailBody(
          viewModel: viewModel,
          showResetToLatest: controller.intent.isFocused,
          onResetToLatest: _resetToLatest,
          showReportAction: true,
          onExportReport: _openReportPreview,
        );
      },
    );
  }
}
