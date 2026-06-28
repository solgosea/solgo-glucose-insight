import '../../../data/probe/platform/package_probe_snapshot.dart';
import '../../../domain/probe/status_probe_definition.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_state.dart';
import 'status_probe_result_helpers.dart';

StatusProbeResult packageProbeResult({
  required StatusProbeDefinition definition,
  required PackageProbeSnapshot snapshot,
  required DateTime observedAt,
  required String displayName,
  required String packageName,
}) {
  final installed = snapshot.installed && snapshot.visible;
  final hasError = snapshot.hasError;
  return probeResult(
    definition: definition,
    state: installed
        ? StatusProbeState.healthy
        : hasError
            ? StatusProbeState.unknown
            : StatusProbeState.notObserved,
    observedAt: observedAt,
    summary: installed
        ? '$displayName package is installed and visible.'
        : hasError
            ? '$displayName package query failed.'
            : '$displayName package was not observed on this device.',
    confidence: installed
        ? 1
        : hasError
            ? 0
            : 0.2,
    evidence: [
      evidence('Package', packageName, observedAt: snapshot.checkedAt),
      if (snapshot.versionName != null)
        evidence('Version', snapshot.versionName!,
            observedAt: snapshot.checkedAt),
      if (snapshot.versionCode != null)
        evidence(
          'Version code',
          snapshot.versionCode.toString(),
          observedAt: snapshot.checkedAt,
        ),
      if (snapshot.error != null)
        evidence('Query error', snapshot.error!,
            observedAt: snapshot.checkedAt),
    ],
    sourceRefs: [
      sourceRef('android.packageManager', 'package:$packageName'),
    ],
  );
}

StatusProbeResult packageCandidatesProbeResult({
  required StatusProbeDefinition definition,
  required List<PackageProbeSnapshot> snapshots,
  required DateTime observedAt,
  required String displayName,
  required List<String> packageNames,
}) {
  PackageProbeSnapshot? installedSnapshot;
  for (final snapshot in snapshots) {
    if (snapshot.installed && snapshot.visible) {
      installedSnapshot = snapshot;
      break;
    }
  }

  final hasError = snapshots.any((snapshot) => snapshot.hasError);
  final installed = installedSnapshot != null;
  final displayPackage = installedSnapshot?.packageName ??
      (packageNames.isNotEmpty ? packageNames.first : displayName);

  return probeResult(
    definition: definition,
    state: installed
        ? StatusProbeState.healthy
        : hasError
            ? StatusProbeState.unknown
            : StatusProbeState.notObserved,
    observedAt: observedAt,
    summary: installed
        ? '$displayName package is installed and visible.'
        : hasError
            ? '$displayName package query failed.'
            : '$displayName package was not observed on this device.',
    confidence: installed
        ? 1
        : hasError
            ? 0
            : 0.2,
    evidence: [
      evidence('Package', displayPackage,
          observedAt: installedSnapshot?.checkedAt ?? observedAt),
      if (installedSnapshot?.versionName != null)
        evidence('Version', installedSnapshot!.versionName!,
            observedAt: installedSnapshot.checkedAt),
      if (installedSnapshot?.versionCode != null)
        evidence(
          'Version code',
          installedSnapshot!.versionCode.toString(),
          observedAt: installedSnapshot.checkedAt,
        ),
      if (!installed)
        evidence('Checked packages', packageNames.join(', '),
            observedAt: observedAt),
      for (final snapshot in snapshots)
        if (snapshot.error != null)
          evidence('Query error', snapshot.error!,
              observedAt: snapshot.checkedAt),
    ],
    sourceRefs: [
      for (final packageName in packageNames)
        sourceRef('android.packageManager', 'package:$packageName'),
    ],
  );
}
