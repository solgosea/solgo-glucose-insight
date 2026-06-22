import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import '../../domain/component_health.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../domain/status_metric.dart';
import '../../domain/status_metric_source.dart';
import '../../domain/status_report.dart';
import '../../domain/status_source_capabilities.dart';
import '../../application/i18n/status_monitor_l10n_resolver.dart';
import '../models/status_dashboard_state.dart';
import '../models/status_view_models.dart';
import '../styles/status_monitor_theme.dart';
import '../widgets/setup_prompt/status_setup_prompt_mapper.dart';

class StatusDashboardStateMapper {
  final StatusSetupPromptMapper setupPromptMapper;

  const StatusDashboardStateMapper({
    this.setupPromptMapper = const StatusSetupPromptMapper(),
  });

  StatusDashboardState map({
    required StatusDashboardViewModel? viewModel,
    required Object? error,
    required bool loading,
  }) {
    final l10n = StatusMonitorL10nResolver.fallback;
    final fallbackReport = _fallbackReport();
    final effectiveViewModel = viewModel ??
        StatusDashboardViewModel(
          report: fallbackReport,
          components: fallbackReport.components
              .map(
                (component) => StatusDashboardComponentViewModel(
                  component: component,
                  freshnessText: l10n.dashboardWaitingForSource,
                ),
              )
              .toList(growable: false),
        );
    return StatusDashboardState(
      viewModel: effectiveViewModel,
      setupPrompt: setupPromptMapper.map(effectiveViewModel.report),
      notice: _notice(
        error: error,
        loading: loading,
        hasReport: viewModel != null,
      ),
      refreshing: loading,
    );
  }

  StatusDashboardNotice? _notice({
    required Object? error,
    required bool loading,
    required bool hasReport,
  }) {
    final l10n = StatusMonitorL10nResolver.fallback;
    if (error != null) {
      return StatusDashboardNotice(
        icon: Icons.warning_amber_rounded,
        accentColor: StatusMonitorTheme.amber,
        title: l10n.dashboardTemporarilyUnavailable,
        body: l10n.dashboardRefreshFailedBody,
      );
    }
    if (loading && !hasReport) {
      return StatusDashboardNotice(
        icon: Icons.sync_rounded,
        accentColor: StatusMonitorTheme.blue,
        title: l10n.dashboardCheckingStatus,
        body: l10n.dashboardPreparingLatest,
      );
    }
    return null;
  }

  StatusReport _fallbackReport() {
    final l10n = StatusMonitorL10nResolver.fallback;
    final now = DateTime.now();
    final components = StatusComponentKind.values
        .map(
          (kind) => ComponentHealth(
            kind: kind,
            level: StatusLevel.unknown,
            title: kind.title,
            role: kind.role,
            takeaway: l10n.dashboardWaitingTakeaway,
            summary: l10n.dashboardNoSourceSummary,
            metrics: [
              StatusMetric(
                id: '${kind.name}_source',
                label: l10n.dashboardSourceLabel,
                valueLabel: l10n.dashboardNotConfigured,
                level: StatusLevel.unknown,
                source: StatusMetricSource.localCache,
                observedAt: now,
              ),
            ],
          ),
        )
        .toList(growable: false);
    return StatusReport(
      subjectId: GlucoseSubject.selfId,
      sourceKind: 'none',
      sourceLabel: l10n.dashboardNoSource,
      generatedAt: now,
      summary: StatusSummary(
        level: StatusLevel.unknown,
        headline: l10n.dashboardNeedsSourceHeadline,
        body: l10n.dashboardNeedsSourceBody,
        meta: l10n.dashboardNeedsSourceMeta,
        healthyCount: 0,
        totalCount: 3,
      ),
      components: components,
      recentEvents: const [],
      capabilities: const StatusSourceCapabilities.none(),
      hasConfiguredSource: false,
      emptyReason: l10n.dashboardNeedsSourceEmptyReason,
    );
  }
}
