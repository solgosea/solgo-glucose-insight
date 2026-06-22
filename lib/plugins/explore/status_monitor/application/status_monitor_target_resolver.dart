import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_registry.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_status.dart';
import 'package:smart_xdrip/application/data_source/data_source_connection_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';

import 'status_monitor_target_resolution.dart';

class StatusMonitorTargetResolver {
  final NightscoutSyncTargetRegistry targetRegistry;
  final AppSettings Function() settingsProvider;

  const StatusMonitorTargetResolver({
    required this.targetRegistry,
    required this.settingsProvider,
  });

  StatusMonitorTargetResolution resolve(AnalysisSubject subject) {
    if (subject.isSelf) {
      final xdrip = _selfXdripFallback(subject.id);
      if (xdrip != null && xdrip.enabled) return xdrip;
    }

    final enabledTarget = _enabledTargetForSubject(subject.id);
    if (enabledTarget != null) {
      return _nightscoutResolution(subject.id, enabledTarget);
    }

    if (subject.isSelf) {
      final xdrip = _selfXdripFallback(subject.id);
      if (xdrip != null) return xdrip;
    }

    final target = _disabledOrLatestTargetForSubject(subject.id);
    if (target != null) {
      return _nightscoutResolution(subject.id, target);
    }

    return StatusMonitorTargetResolution.none(subjectId: subject.id);
  }

  StatusMonitorTargetResolution? resolveEnabledNightscout(
    AnalysisSubject subject,
  ) {
    final target = _enabledTargetForSubject(subject.id);
    if (target == null) return null;
    return _nightscoutResolution(subject.id, target);
  }

  StatusMonitorTargetResolution? resolveSelfXdripLocal(
    AnalysisSubject subject,
  ) {
    return _selfXdripFallback(subject.id);
  }

  NightscoutSyncTarget? _enabledTargetForSubject(String subjectId) {
    final targets = targetRegistry.targetsForSubject(subjectId);
    if (targets.isEmpty) return null;
    final active = targets.where((target) => target.enabled).toList();
    return active.isEmpty ? null : _latest(active);
  }

  NightscoutSyncTarget? _disabledOrLatestTargetForSubject(String subjectId) {
    final targets = targetRegistry.targetsForSubject(subjectId);
    if (targets.isEmpty) return null;
    final disabled = targets
        .where((target) => target.status == NightscoutSyncTargetStatus.disabled)
        .toList();
    if (disabled.isNotEmpty) return _latest(disabled);
    return _latest(targets);
  }

  NightscoutSyncTarget _latest(List<NightscoutSyncTarget> targets) {
    return targets.reduce(
      (a, b) => a.updatedAt.isAfter(b.updatedAt) ? a : b,
    );
  }

  StatusMonitorTargetResolution _nightscoutResolution(
    String subjectId,
    NightscoutSyncTarget target,
  ) {
    return StatusMonitorTargetResolution(
      subjectId: subjectId,
      sourceKind: StatusMonitorTargetSourceKind.nightscout,
      targetId: target.targetId,
      sourceLabel: target.label,
      baseUrl: target.normalizedUrl,
      token: target.accessToken,
      enabled: target.enabled,
      unavailableReason:
          target.enabled ? null : '${target.label} is configured but disabled.',
      target: target,
    );
  }

  StatusMonitorTargetResolution? _selfXdripFallback(String subjectId) {
    final settings = settingsProvider();
    final configuredBaseUrl = settings.xdripBaseUrl?.trim();
    final baseUrl = configuredBaseUrl != null && configuredBaseUrl.isNotEmpty
        ? configuredBaseUrl
        : settings.xdripSyncEnabled
            ? DataSourceConnectionService.defaultXdripUrl
            : null;
    if (baseUrl == null) return null;
    return StatusMonitorTargetResolution(
      subjectId: subjectId,
      sourceKind: StatusMonitorTargetSourceKind.xdripLocal,
      targetId: 'self:xdrip-local',
      sourceLabel: 'xDrip+ Local',
      baseUrl: baseUrl,
      token: settings.xdripApiSecret,
      enabled: true,
    );
  }
}
