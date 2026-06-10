import '../../domain/subject/analysis_subject.dart';
import '../../domain/subject/analysis_subject_origin.dart';
import '../../domain/subject/glucose_subject.dart';

class ActiveSubjectDefaults {
  static const self = AnalysisSubject(
    id: GlucoseSubject.selfId,
    displayName: 'My device',
    sourceLabel: 'Active datasource',
    origin: AnalysisSubjectOrigin.self,
  );

  const ActiveSubjectDefaults._();
}
