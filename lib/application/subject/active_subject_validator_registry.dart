import '../../domain/subject/analysis_subject.dart';
import 'active_subject_validation_result.dart';
import 'active_subject_validator.dart';

class ActiveSubjectValidatorRegistry {
  final List<ActiveSubjectValidator> _validators = [];

  void register(ActiveSubjectValidator validator) {
    _validators.add(validator);
  }

  Future<ActiveSubjectValidationResult> validate(
    AnalysisSubject subject,
  ) async {
    for (final validator in _validators) {
      if (!validator.supports(subject)) continue;
      return validator.validate(subject);
    }
    return const ActiveSubjectValidationResult.valid();
  }
}
