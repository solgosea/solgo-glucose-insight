import '../../domain/subject/analysis_subject.dart';
import 'active_subject_service.dart';

class ActiveSubjectSwitcher {
  final ActiveSubjectService service;

  const ActiveSubjectSwitcher({required this.service});

  Future<AnalysisSubject> switchTo(AnalysisSubject subject) async {
    await service.switchTo(subject);
    return subject;
  }

  Future<AnalysisSubject> switchToSelf() async {
    await service.switchToSelf();
    return service.current;
  }
}
