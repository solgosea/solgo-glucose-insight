import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import '../../domain/component_health.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../../domain/status_metric.dart';
import '../../domain/status_metric_source.dart';
import '../../domain/status_report.dart';
import '../../domain/status_source_capabilities.dart';
import '../../application/checking/models/status_check_component_phase.dart';
import '../../application/checking/models/status_check_session_state.dart';
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
    StatusCheckSessionState? sessionState,
    required Object? error,
    required bool loading,
  }) {
    final effectiveViewModel = _withActiveCheckOverlay(
          viewModel,
          sessionState,
        ) ??
        viewModel ??
        _sessionViewModel(sessionState) ??
        _fallbackViewModel();
    return StatusDashboardState(
      viewModel: effectiveViewModel,
      setupPrompt: setupPromptMapper.map(effectiveViewModel.report),
      notice: _notice(
        error: error,
        loading: loading,
        hasReport: viewModel != null || sessionState != null,
      ),
      refreshing: loading,
    );
  }

  StatusDashboardViewModel? _withActiveCheckOverlay(
    StatusDashboardViewModel? viewModel,
    StatusCheckSessionState? sessionState,
  ) {
    if (viewModel == null || sessionState == null) return viewModel;
    final activeStates = {
      for (final state in sessionState.components)
        if (_isActiveCheckPhase(state.phase)) state.kind: state,
    };
    if (activeStates.isEmpty) return viewModel;
    final components = viewModel.components.map((component) {
      final checkState = activeStates[component.component.kind];
      if (checkState == null) return component;
      return StatusDashboardComponentViewModel(
        component: component.component,
        freshnessText:
            _freshnessForPhase(checkState.phase, checkState.stepLabel),
        checkPhase: checkState.phase,
        checkStepLabel: checkState.stepLabel,
      );
    }).toList(growable: false);
    return StatusDashboardViewModel(
      report: viewModel.report,
      components: components,
    );
  }

  bool _isActiveCheckPhase(StatusCheckComponentPhase phase) {
    return phase == StatusCheckComponentPhase.queued ||
        phase == StatusCheckComponentPhase.checking;
  }

  StatusDashboardViewModel _fallbackViewModel() {
    final l10n = StatusMonitorL10nResolver.fallback;
    final fallbackReport = _fallbackReport();
    return StatusDashboardViewModel(
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
  }

  StatusDashboardViewModel? _sessionViewModel(
    StatusCheckSessionState? sessionState,
  ) {
    if (sessionState == null) return null;
    final l10n = StatusMonitorL10nResolver.fallback;
    final now = DateTime.now();
    final components = sessionState.components.map((state) {
      final health = state.health ??
          ComponentHealth(
            kind: state.kind,
            level: state.phase == StatusCheckComponentPhase.failed
                ? StatusLevel.issue
                : StatusLevel.unknown,
            title: state.kind.title,
            role: state.kind.role,
            takeaway: _phaseTitle(state.phase),
            summary: state.stepLabel.isEmpty
                ? l10n.dashboardPreparingLatest
                : state.stepLabel,
            metrics: [
              StatusMetric(
                id: '${state.kind.name}_check_phase',
                label: l10n.dashboardSourceLabel,
                valueLabel: _phaseTitle(state.phase),
                level: state.phase == StatusCheckComponentPhase.failed
                    ? StatusLevel.issue
                    : StatusLevel.unknown,
                source: StatusMetricSource.localCache,
                observedAt: now,
              ),
            ],
          );
      return StatusDashboardComponentViewModel(
        component: health,
        freshnessText: _freshnessForPhase(state.phase, state.stepLabel),
        checkPhase: state.phase,
        checkStepLabel: state.stepLabel,
      );
    }).toList(growable: false);
    final completed = sessionState.completedCount;
    final total = sessionState.totalCount;
    final report = StatusReport(
      subjectId: sessionState.subjectId,
      sourceKind: 'checking',
      sourceLabel: 'Status checks',
      generatedAt: sessionState.startedAt,
      summary: StatusSummary(
        level: StatusLevel.unknown,
        headline: 'Checking status components.',
        body: 'Checking $completed of $total components.',
        meta: 'Fresh check session in progress',
        healthyCount: components
            .where(
                (component) => component.component.level == StatusLevel.healthy)
            .length,
        totalCount: total,
      ),
      components: components.map((model) => model.component).toList(),
      recentEvents: const [],
      capabilities: const StatusSourceCapabilities.none(),
      hasConfiguredSource: true,
    );
    return StatusDashboardViewModel(report: report, components: components);
  }

  String _phaseTitle(StatusCheckComponentPhase phase) {
    return switch (phase) {
      StatusCheckComponentPhase.queued => 'Queued',
      StatusCheckComponentPhase.checking => 'Checking',
      StatusCheckComponentPhase.completed => 'Checked',
      StatusCheckComponentPhase.failed => 'Could not check',
      StatusCheckComponentPhase.skipped => 'Skipped',
      StatusCheckComponentPhase.cancelled => 'Cancelled',
    };
  }

  String _freshnessForPhase(StatusCheckComponentPhase phase, String stepLabel) {
    return switch (phase) {
      StatusCheckComponentPhase.queued => 'Queued',
      StatusCheckComponentPhase.checking =>
        stepLabel.isEmpty ? 'Checking now' : stepLabel,
      StatusCheckComponentPhase.completed => 'Checked just now',
      StatusCheckComponentPhase.failed => 'Check failed',
      StatusCheckComponentPhase.skipped => 'Skipped',
      StatusCheckComponentPhase.cancelled => 'Cancelled',
    };
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
