import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../../application/hub/status_hub_controller_facade.dart';
import '../../../application/probe_scenario/engine/status_probe_scenario_engine.dart';
import '../../../application/probe/runtime/status_probe_result_cache.dart';
import '../../../application/status_monitor_target_resolver.dart';
import '../../styles/status_monitor_theme.dart';
import '../../widgets/status_monitor_page_header.dart';
import '../../widgets/status_monitor_top_nav.dart';
import '../controllers/status_hub_controller.dart';
import '../widgets/status_hub_body.dart';
import '../widgets/status_hub_empty_state.dart';

class StatusHubPage extends StatefulWidget {
  const StatusHubPage({super.key});

  @override
  State<StatusHubPage> createState() => _StatusHubPageState();
}

class _StatusHubPageState extends State<StatusHubPage> {
  StatusHubController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final services = context.read<PluginServiceRegistry>();
    _controller ??= StatusHubController(
      facade: StatusHubControllerFacade(
        activeSubjectService: services.get<ActiveSubjectService>(),
        targetResolver: services.get<StatusMonitorTargetResolver>(),
        scenarioEngine: services.get<StatusProbeScenarioEngine>(),
        resultCache: services.get<StatusProbeResultCache>(),
      ),
    )..load();
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
                      onRefresh: controller.load,
                      child: ListView(
                        padding: const EdgeInsets.only(bottom: 24),
                        children: [
                          _HubPageWidth(
                            child: StatusMonitorPageHeader(
                              eyebrow: 'Status Monitor',
                              title: viewModel?.title ?? 'xDrip+ Hub',
                              subtitle: viewModel?.subtitle ??
                                  'Connection map centered on xDrip+',
                              onBack: () => context.canPop()
                                  ? context.pop()
                                  : context.go('/explore/status'),
                              trailing: IconButton(
                                tooltip: 'Refresh checks',
                                onPressed:
                                    controller.loading ? null : controller.load,
                                icon: const Icon(Icons.refresh_rounded),
                                color: StatusMonitorTheme.green,
                                style: IconButton.styleFrom(
                                  backgroundColor: StatusMonitorTheme.card2,
                                ),
                              ),
                            ),
                          ),
                          _HubPageWidth(
                            child: const StatusMonitorTopNav(
                              current: StatusMonitorTopNavDestination.hub,
                            ),
                          ),
                          if (viewModel == null)
                            _HubPageWidth(
                              child: StatusHubEmptyState(
                                loading: controller.loading,
                                error: controller.error,
                              ),
                            )
                          else
                            _HubPageWidth(
                              child: StatusHubBody(viewModel: viewModel),
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

class _HubPageWidth extends StatelessWidget {
  final Widget child;

  const _HubPageWidth({required this.child});

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
