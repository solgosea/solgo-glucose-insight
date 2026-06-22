import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../runtime/status_monitor_runtime.dart';
import '../../runtime/status_monitor_runtime_cache.dart';
import '../../application/history/status_history_service.dart';
import '../../application/i18n/status_monitor_l10n.dart';
import '../controllers/status_history_controller.dart';
import '../styles/status_monitor_theme.dart';
import '../widgets/status_history_chart.dart';
import '../widgets/status_monitor_page_header.dart';

class StatusHistoryPage extends StatefulWidget {
  const StatusHistoryPage({super.key});

  @override
  State<StatusHistoryPage> createState() => _StatusHistoryPageState();
}

class _StatusHistoryPageState extends State<StatusHistoryPage> {
  StatusHistoryController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final services = context.read<PluginServiceRegistry>();
    context.read<PluginRuntimeManager>().resume(StatusMonitorRuntime.id);
    _controller = StatusHistoryController(
      cache: services.get<StatusMonitorRuntimeCache>(),
      historyService: services.get<StatusHistoryService>(),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.statusMonitorL10n;
    final controller = _controller;
    return Scaffold(
      backgroundColor: StatusMonitorTheme.bg,
      body: SafeArea(
        child: controller == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: StatusMonitorTheme.green,
                ),
              )
            : ListenableBuilder(
                listenable: controller,
                builder: (context, _) => ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    StatusMonitorPageHeader(
                      eyebrow: l10n.pageEyebrowStatusMonitor,
                      title: l10n.pageHistoryTitle,
                      subtitle: l10n.pageHistorySubtitle,
                      onBack: () => context.pop(),
                    ),
                    StatusHistoryChart(
                      viewModel: controller.viewModel,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
