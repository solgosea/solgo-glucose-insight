import '../sources/i_glucose_source.dart';
import 'glucose_sync_target_kind.dart';

class GlucoseSyncTarget {
  final String targetId;
  final String subjectId;
  final String label;
  final GlucoseSyncTargetKind kind;
  final IGlucoseSource source;
  final bool primaryHistory;
  final bool enabled;

  const GlucoseSyncTarget({
    required this.targetId,
    required this.subjectId,
    required this.label,
    required this.kind,
    required this.source,
    this.primaryHistory = false,
    this.enabled = true,
  });
}
