import '../../domain/subject/analysis_subject.dart';

class ActiveSubjectValidationResult {
  final bool resetToSelf;
  final AnalysisSubject? refreshedSubject;

  const ActiveSubjectValidationResult._({
    required this.resetToSelf,
    this.refreshedSubject,
  });

  const ActiveSubjectValidationResult.valid({AnalysisSubject? refreshedSubject})
    : this._(resetToSelf: false, refreshedSubject: refreshedSubject);

  const ActiveSubjectValidationResult.invalid() : this._(resetToSelf: true);
}
