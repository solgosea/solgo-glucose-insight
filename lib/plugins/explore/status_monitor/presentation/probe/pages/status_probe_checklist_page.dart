import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../../application/probe/catalog/status_probe_catalog_service.dart';
import '../../../application/probe_scenario/engine/status_probe_scenario_engine.dart';
import '../../../application/status_monitor_target_resolver.dart';
import '../../styles/status_monitor_theme.dart';
import '../../widgets/status_monitor_page_header.dart';
import '../../widgets/status_monitor_top_nav.dart';
import '../controllers/status_probe_checklist_controller.dart';
import '../widgets/checklist/status_probe_checklist_body.dart';

class StatusProbeChecklistPage extends StatefulWidget {
  final String? debugNightscoutBaseUrl;
  final String? debugNightscoutToken;
  final String? debugRunId;

  const StatusProbeChecklistPage({
    super.key,
    this.debugNightscoutBaseUrl,
    this.debugNightscoutToken,
    this.debugRunId,
  });

  @override
  State<StatusProbeChecklistPage> createState() =>
      _StatusProbeChecklistPageState();
}

class _StatusProbeChecklistPageState extends State<StatusProbeChecklistPage> {
  StatusProbeChecklistController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    _createController();
  }

  @override
  void didUpdateWidget(covariant StatusProbeChecklistPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.debugNightscoutBaseUrl == widget.debugNightscoutBaseUrl &&
        oldWidget.debugNightscoutToken == widget.debugNightscoutToken &&
        oldWidget.debugRunId == widget.debugRunId) {
      return;
    }
    _controller?.dispose();
    _controller = null;
    _createController();
  }

  void _createController() {
    final services = context.read<PluginServiceRegistry>();
    final controller = StatusProbeChecklistController(
      scenarioEngine: services.get<StatusProbeScenarioEngine>(),
      catalogService: services.get<StatusProbeCatalogService>(),
      activeSubjectService: services.get<ActiveSubjectService>(),
      targetResolver: services.get<StatusMonitorTargetResolver>(),
      debugNightscoutBaseUrl: widget.debugNightscoutBaseUrl,
      debugNightscoutToken: widget.debugNightscoutToken,
    );
    _controller = controller;
    Future.microtask(controller.load);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: StatusMonitorTheme.bg,
      body: SafeArea(
        child: DecoratedBox(
          decoration: StatusMonitorTheme.pageBackground(),
          child: controller == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: StatusMonitorTheme.green,
                  ),
                )
              : ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    final viewModel = controller.viewModel;
                    return RefreshIndicator(
                      color: StatusMonitorTheme.green,
                      backgroundColor: StatusMonitorTheme.card,
                      onRefresh: controller.runChecks,
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 28),
                        children: [
                          _ProbePageWidth(
                            child: StatusMonitorPageHeader(
                              eyebrow: 'Status Monitor',
                              title: viewModel.title,
                              subtitle: viewModel.subtitle,
                              onBack: () => context.canPop()
                                  ? context.pop()
                                  : context.go('/explore/status'),
                              trailing: IconButton(
                                tooltip: 'Run checks',
                                onPressed: viewModel.loading
                                    ? null
                                    : controller.runChecks,
                                icon: const Icon(Icons.refresh_rounded),
                                color: StatusMonitorTheme.green,
                                style: IconButton.styleFrom(
                                  backgroundColor: StatusMonitorTheme.card2,
                                ),
                              ),
                            ),
                          ),
                          _ProbePageWidth(
                            child: const StatusMonitorTopNav(
                              current: StatusMonitorTopNavDestination.checklist,
                            ),
                          ),
                          _ProbePageWidth(
                            child: StatusProbeChecklistBody(
                              viewModel: viewModel,
                              onRun: controller.runChecks,
                              onOpenGuide: (route) => context.push(route),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _ProbePageWidth extends StatelessWidget {
  final Widget child;

  const _ProbePageWidth({required this.child});

  @override
  Widget build(BuildContext context) {
    final maxWidth = StatusMonitorTheme.isTablet(context)
        ? StatusMonitorTheme.tabletContentWidth
        : StatusMonitorTheme.phoneContentWidth;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
