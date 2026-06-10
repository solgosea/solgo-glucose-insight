import '../../domain/subject/analysis_subject.dart';
import 'active_subject_validation_result.dart';

abstract interface class ActiveSubjectValidator {
  bool supports(AnalysisSubject subject);

  Future<ActiveSubjectValidationResult> validate(AnalysisSubject subject);
}
