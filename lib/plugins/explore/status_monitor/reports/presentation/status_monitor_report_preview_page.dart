import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../application/status_monitor_service.dart';
import '../status_monitor_report_preview_controller.dart';
import 'status_monitor_report_preview_body.dart';

class StatusMonitorReportPreviewPage extends StatefulWidget {
  const StatusMonitorReportPreviewPage({super.key});

  @override
  State<StatusMonitorReportPreviewPage> createState() =>
      _StatusMonitorReportPreviewPageState();
}

class _StatusMonitorReportPreviewPageState
    extends State<StatusMonitorReportPreviewPage> {
  late final StatusMonitorReportPreviewController _controller;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final services = context.read<PluginServiceRegistry>();
    _controller = StatusMonitorReportPreviewController(
      service: services.get<StatusMonitorService>(),
    );
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
        return StatusMonitorReportPreviewBody(
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
    router.go('/explore/status');
  }
}
