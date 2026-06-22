import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../application/episode_detail_route_codec.dart';
import '../../../models/episode_kind.dart';
import '../../high/high_episode_report_preview_controller.dart';
import 'high_episode_report_preview_body.dart';

class HighEpisodeReportPreviewPage extends StatefulWidget {
  final Uri uri;

  const HighEpisodeReportPreviewPage({
    super.key,
    required this.uri,
  });

  @override
  State<HighEpisodeReportPreviewPage> createState() =>
      _HighEpisodeReportPreviewPageState();
}

class _HighEpisodeReportPreviewPageState
    extends State<HighEpisodeReportPreviewPage> {
  late final HighEpisodeReportPreviewController _controller;
  final _routeCodec = const EpisodeDetailRouteCodec();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final intent = _routeCodec.decode(
      widget.uri,
      kind: EpisodeKind.high,
      defaultSource: 'report-preview',
    );
    _controller = HighEpisodeReportPreviewController(intent: intent);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _controller.load(locale: Localizations.localeOf(context));
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
        return HighEpisodeReportPreviewBody(
          controller: _controller,
          snapshot: _controller.snapshot,
          loading: _controller.loading,
          exporting: _controller.exporting,
          error: _controller.error,
          onBack: () => _back(context),
        );
      },
    );
  }

  void _back(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
      return;
    }
    router.go('/explore/high-episode');
  }
}
