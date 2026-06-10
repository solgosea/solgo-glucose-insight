import 'analysis_subject_origin.dart';
import 'glucose_subject.dart';

class AnalysisSubject {
  final String id;
  final String displayName;
  final String sourceLabel;
  final AnalysisSubjectOrigin origin;

  const AnalysisSubject({
    required this.id,
    required this.displayName,
    required this.sourceLabel,
    required this.origin,
  });

  bool get isSelf => GlucoseSubject.isSelf(id);
}
