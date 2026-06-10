import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

class GlucoseSourceDescriptor {
  final String targetId;
  final String subjectId;
  final String label;
  final IGlucoseSource source;
  final bool primaryHistory;

  GlucoseSourceDescriptor({
    String? targetId,
    this.subjectId = GlucoseSubject.selfId,
    String? label,
    required this.source,
    this.primaryHistory = false,
  }) : targetId = targetId ?? 'self:${source.type.name}',
       label = label ?? source.type.name;
}
