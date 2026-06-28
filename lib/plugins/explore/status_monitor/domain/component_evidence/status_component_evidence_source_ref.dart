import '../probe/status_probe_source_ref.dart';

enum StatusComponentEvidenceSourceKind {
  probe,
  localReadings,
  remoteApi,
  cachedReadings,
  derived,
  unavailable,
}

class StatusComponentEvidenceSourceRef {
  final StatusComponentEvidenceSourceKind kind;
  final String source;
  final String? path;
  final StatusProbeSourceRef? probeSource;

  const StatusComponentEvidenceSourceRef({
    required this.kind,
    required this.source,
    this.path,
    this.probeSource,
  });

  const StatusComponentEvidenceSourceRef.probe({
    required String probeId,
    String? path,
    StatusProbeSourceRef? probeSource,
  }) : this(
          kind: StatusComponentEvidenceSourceKind.probe,
          source: probeId,
          path: path,
          probeSource: probeSource,
        );

  const StatusComponentEvidenceSourceRef.derived(String source)
      : this(kind: StatusComponentEvidenceSourceKind.derived, source: source);

  const StatusComponentEvidenceSourceRef.unavailable(String source)
      : this(
          kind: StatusComponentEvidenceSourceKind.unavailable,
          source: source,
        );
}
