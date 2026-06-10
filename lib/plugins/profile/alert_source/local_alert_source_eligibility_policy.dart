import '../../../domain/entities/app_settings.dart';
import '../../../domain/subject/glucose_subject.dart';

class LocalAlertSourceEligibilityPolicy {
  const LocalAlertSourceEligibilityPolicy();

  bool canEvaluate({
    required String subjectId,
    required AppSettings settings,
  }) {
    if (!GlucoseSubject.isSelf(subjectId)) {
      return false;
    }
    return settings.xdripSyncEnabled || settings.nightscoutSyncEnabled;
  }
}
