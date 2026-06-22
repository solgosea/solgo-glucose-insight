import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../runtime/status_monitor_runtime.dart';
import '../../runtime/status_monitor_runtime_cache.dart';
import '../../application/i18n/status_monitor_l10n.dart';
import '../controllers/status_dashboard_controller.dart';
import '../styles/status_monitor_theme.dart';
import '../widgets/dashboard/status_dashboard_content.dart';
import '../widgets/status_monitor_page_header.dart';

class StatusDashboardPage extends StatefulWidget {
  const StatusDashboardPage({super.key});

  @override
  State<StatusDashboardPage> createState() => _StatusDashboardPageState();
}

class _StatusDashboardPageState extends State<StatusDashboardPage> {
  StatusDashboardController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.statusMonitorL10n;
    final controller = _controller;
    if (controller != null) {
      controller.setLocalizations(l10n);
      return;
    }
    final services = context.read<PluginServiceRegistry>();
    context.read<PluginRuntimeManager>().resume(StatusMonitorRuntime.id);
    _controller = StatusDashboardController(
      cache: services.get<StatusMonitorRuntimeCache>(),
    )..setLocalizations(l10n);
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
                builder: (context, _) => RefreshIndicator(
                  color: StatusMonitorTheme.green,
                  backgroundColor: StatusMonitorTheme.card,
                  onRefresh: () => context
                      .read<PluginRuntimeManager>()
                      .resume(StatusMonitorRuntime.id),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
                      StatusMonitorPageHeader(
                        eyebrow: l10n.pageEyebrowLiveStatus,
                        title: l10n.pluginTitle,
                        subtitle: l10n.pageDashboardSubtitle,
                        onBack: () => context.canPop()
                            ? context.pop()
                            : context.go('/explore'),
                        trailing: IconButton(
                          tooltip: l10n.pageReportTooltip,
                          onPressed: () =>
                              context.push('/explore/status/report-preview'),
                          icon: const Icon(Icons.picture_as_pdf_rounded),
                          color: StatusMonitorTheme.green,
                          style: IconButton.styleFrom(
                            backgroundColor: StatusMonitorTheme.card2,
                          ),
                        ),
                      ),
                      StatusDashboardContent(
                        controller: controller,
                        onOpenWidgets: () =>
                            context.push('/explore/status/widgets'),
                        onOpenHistory: () =>
                            context.push('/explore/status/history'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
