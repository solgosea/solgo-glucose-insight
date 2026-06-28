import 'package:flutter/material.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugins/explore/composition/explore_slots.dart';

import 'composition/status_monitor_placement.dart';
import 'domain/status_component_kind.dart';
import 'install/status_monitor_install_module.dart';
import 'presentation/pages/status_component_detail_page.dart';
import 'presentation/pages/status_dashboard_page.dart';
import 'presentation/pages/status_history_page.dart';
import 'presentation/pages/status_widgets_notifications_page.dart';
import 'presentation/hub/pages/status_hub_page.dart';
import 'presentation/probe/pages/aaps_downstream_checks_page.dart';
import 'presentation/probe/pages/juggluco_probe_guide_page.dart';
import 'presentation/probe/pages/nightscout_probe_guide_page.dart';
import 'presentation/probe/pages/status_probe_checklist_page.dart';
import 'presentation/probe/pages/watch_probe_guide_page.dart';
import 'presentation/probe/pages/xdrip_probe_guide_page.dart';
import 'reports/presentation/status_monitor_report_preview_page.dart';
import 'runtime/status_monitor_runtime.dart';
import 'application/i18n/status_monitor_entry_localizer.dart';
import 'application/i18n/status_monitor_l10n_resolver.dart';

class StatusMonitorPlugin extends SmartFeaturePlugin {
  const StatusMonitorPlugin();

  static final _strings = StatusMonitorL10nResolver.fallback;

  @override
  PluginId get id => StatusMonitorRuntime.id;

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.beta;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.exploreCard};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {};

  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: ExploreSlots.card,
          renderKey: StatusMonitorPlacement.renderKey,
          title: StatusMonitorPlacement.title,
          order: StatusMonitorPlacement.order,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  ExplorePluginEntry get exploreEntry => ExplorePluginEntry(
        section: _strings.pluginExploreSection,
        title: _strings.pluginTitle,
        subtitle: _strings.pluginSubtitle,
        route: '/explore/status',
        icon: Icons.monitor_heart_rounded,
        accentColor: Color(0xFF6EE69E),
        order: StatusMonitorPlacement.order,
      );

  @override
  List<PluginRoute> get routes => [
        PluginRoute(
          path: '/explore/status',
          builder: (_) => const StatusDashboardPage(),
        ),
        PluginRoute.state(
          path: '/explore/status/component',
          builder: (_, state) => StatusComponentDetailPage(
            kind: StatusComponentKind.fromQuery(
              state.uri.queryParameters['kind'],
            ),
          ),
        ),
        PluginRoute(
          path: '/explore/status/history',
          builder: (_) => const StatusHistoryPage(),
        ),
        PluginRoute(
          path: '/explore/status/hub',
          builder: (_) => const StatusHubPage(),
        ),
        PluginRoute.state(
          path: '/explore/status/probe-checklist',
          builder: (_, state) => StatusProbeChecklistPage(
            debugNightscoutBaseUrl: state.uri.queryParameters['nightscoutUrl'],
            debugNightscoutToken: state.uri.queryParameters['nightscoutToken'],
            debugRunId: state.uri.queryParameters['probeRunId'],
          ),
        ),
        PluginRoute(
          path: '/explore/status/probe/xdrip-guide',
          builder: (_) => const XdripProbeGuidePage(),
        ),
        PluginRoute(
          path: '/explore/status/probe/juggluco-guide',
          builder: (_) => const JugglucoProbeGuidePage(),
        ),
        PluginRoute(
          path: '/explore/status/probe/nightscout-guide',
          builder: (_) => const NightscoutProbeGuidePage(),
        ),
        PluginRoute(
          path: '/explore/status/probe/aaps-guide',
          builder: (_) => const AapsDownstreamChecksPage(),
        ),
        PluginRoute(
          path: '/explore/status/probe/watch-guide',
          builder: (_) => const WatchProbeGuidePage(),
        ),
        PluginRoute(
          path: '/explore/status/widgets',
          builder: (_) => const StatusWidgetsNotificationsPage(),
        ),
        PluginRoute(
          path: '/explore/status/report-preview',
          builder: (_) => const StatusMonitorReportPreviewPage(),
        ),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const StatusMonitorEntryLocalizer());
    const StatusMonitorInstallModule().install(context, id);
  }
}
